require 'yaml'
require 'pry' if Rails.env.development? || Rails.env.test?

require 'synergy/adapters/gov_cms_adapter'
require 'synergy/adapters/collaboration_adapter'

module Synergy
  class CMSImport

    ADAPTERS = {
      'GovCMS'      => Synergy::Adapters::GovCMSAdapter,
      'Collaborate' => Synergy::Adapters::CollaborationAdapter
    }.freeze

    def self.import_from_all_sections
      Section.all.each{|section| import_from(section)}
    end

    def self.import_from(section)
      new(make_adapter(section)).run
    end

    def initialize(adapter)
      @adapter = adapter
    end

    def run
      ActiveRecord::Base.transaction(isolation: :read_committed) do
        root_node = SynergyNode.find_or_create_by!(path: '/', source_name: 'synergy')
        @adapter.log "deleting existing nodes"
        SynergyNode.where(source_name: @adapter.section.slug).delete_all
        @adapter.log "finished deleting existing nodes"

        destination_parts = @adapter.destination_path.split("/").select{|p| !p.blank?}

        @adapter.run do |node_data|
          source_parts = node_data[:path].split("/").select{|p| !p.blank?}
          parts        = destination_parts + source_parts

          leaf = parts.reduce(root_node) do |parent_s_node,slug|
            SynergyNode.find_or_create_by!(
              source_name: @adapter.section.slug,
              parent: parent_s_node,
              slug: slug
            ) do |sn|
              sn.source_url = node_data[:source_url]
            end
          end

          leaf.content    = node_data[:content]
          leaf.title      = node_data[:title]
          leaf.save!
        end
      end
    end

    private

    def self.make_adapter(section)
      ADAPTERS[section.cms_type].new(section)
    end
  end
end
