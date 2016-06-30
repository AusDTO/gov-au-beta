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
      ActiveRecord::Base.transaction(isolation: :read_committed) do
        @adapter.log "deleting existing nodes"
        Page.where(source_name: @adapter.section.slug).delete_all
        @adapter.log "finished deleting existing nodes"

        destination_parts = @adapter.destination_path.split("/").select{|p| !p.blank?}

        @adapter.run do |node_data|
          source_parts = node_data[:path].split("/").select{|p| !p.blank?}
          parts        = destination_parts + source_parts

          Page.create!(
            source_name: @adapter.section.slug,
            path:        "/#{parts.join("/")}",
            cms_ref:     node_data[:cms_ref],
            content:     node_data[:content],
            title:       node_data[:title]
          )
        end
      end
    end

    def self.make_adapter(section)
      ADAPTERS[section.cms_type].new(section)
    end
    private_class_method :make_adapter
  end
end
