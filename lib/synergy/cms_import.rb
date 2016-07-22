require 'yaml'
require 'pry' if Rails.env.development? || Rails.env.test?

require 'synergy/adapters/gov_cms_adapter'

module Synergy
  class CMSImport

    ADAPTERS = {
      'GovCMS'      => Synergy::Adapters::GovCMSAdapter
    }.freeze

    def self.import_from_all_sections
      ADAPTERS.keys.each do |key|
        Section.where('cms_type = ?', key).each do |section|
          import_from(section)
        end
      end
    end

    def self.import_from(section)
      new(make_adapter(section)).run
    end

    def initialize(adapter)
      @adapter = adapter
    end

    def run
      with_muted_logging do
        ActiveRecord::Base.transaction(isolation: :read_committed) do
          clear_existing_nodes
          @adapter.run do |node_data|
            parts = node_data[:path].split("/").select{|p| !p.blank?}
            leaf = build_path_to_leaf_node(parts, node_data)
            write_leaf_content(leaf, node_data)
          end
        end
      end
    end

    private

    def write_leaf_content(leaf, node_data)
      leaf.update_attributes!({
        :name         => node_data[:title],
        :template     => "general_content",
        :cms_url      => node_data[:cms_ref],
        :content_body => translate_absolute_links(absolutify_image_links(node_data[:content])),
      })
    end

    def build_path_to_leaf_node(parts, node_data)
      section_node = SectionHome.find_or_create_by!(section: @adapter.section, parent: Node.root_node)
      parts.reduce(section_node) do |node,part|
        node.children.find_or_create_by!(
          section: @adapter.section,
          parent_id: node.id,
          type: 'GeneralContent',
          slug: part
        ) do |child|
          child.name        = part.gsub("-", " ").humanize
          child.state       = :published
          child.cms_api_url = node_data[:cms_api_url]
        end
      end
    end

    def clear_existing_nodes
      @adapter.log "deleting existing nodes"
      Node.where(section: @adapter.section).delete_all
      @adapter.log "finished deleting existing nodes"
    end

    def with_muted_logging
      logger_level = ActiveRecord::Base.logger.level
      ActiveRecord::Base.logger.level = 1
      begin
        yield
      ensure
        ActiveRecord::Base.logger.level = logger_level
      end
    end

    # Translates absolute links from GovCMS into absolute links in Collaborate.
    # Essentially just adding the section as a path prefix.
    def translate_absolute_links(content)
      return nil if content.blank?
      html = Nokogiri::HTML.fragment(content)
      html.search("a").each do |node|
        href = node["href"]
        unless href.empty?
          if href =~ /^\//
            node["href"] = "/#{@adapter.section.slug}#{href.to_s}"
          end
        end
      end
      html.to_html
    rescue
      Rails.logger.error "[/#{@adapter.section.slug}] Could not parse HTML content: #{$!.message}"
      content
    end

    def absolutify_image_links(content)
      return nil if content.blank?
      html = Nokogiri::HTML.fragment(content)
      html.search("img").each do |node|
        src = node["src"]
        unless src.empty?
          uri = URI.parse(URI.escape(src))
          unless uri.host
            uri.scheme = @adapter.image_base_href.scheme
            uri.host = @adapter.image_base_href.host
            node["src"] = uri.to_s
          end
        end
      end
      html.to_html
    rescue
      Rails.logger.error "[/#{@adapter.section.slug}] Could not parse HTML content: #{$!.message}"
      content
    end

    def self.make_adapter(section)
      ADAPTERS[section.cms_type].new(section)
    end
    private_class_method :make_adapter
  end
end
