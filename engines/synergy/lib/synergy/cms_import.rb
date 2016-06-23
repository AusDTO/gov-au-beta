
require 'yaml'
require 'pry' if Rails.env.development? || Rails.env.test?

require 'synergy/adapters/gov_cms_adapter'
require 'synergy/adapters/collaboration_adapter'

module Synergy
  class CMSImport
    ADAPTERS = {
      'GovCMS'        => Synergy::Adapters::GovCMSAdapter,
      'Collaboration' => Synergy::Adapters::CollaborationAdapter
    }.freeze

    def self.run
      config_path = File.join(Rails.root, "config/synergy.yml")
      config = YAML.load_file(config_path)

      root_node = Synergy::Node.find_or_create_by!(path: '/', source_name: 'synergy')

      config["synergies"].each_pair do |source_name, source_config|
        adapter = ADAPTERS[source_config["type"]].new(
          source_name,
          source_config["url"]
        )
        ActiveRecord::Base.transaction(isolation: :read_committed) do
          adapter.log "deleting existing nodes"
          Synergy::Node.where(source_name: source_name).delete_all
          adapter.log "finished deleting existing nodes"

          destination_parts = source_config["destination_path"].split("/").select{|p| !p.blank?}

          adapter.run do |node_data|
            source_parts = node_data[:path]
            parts        = destination_parts + source_parts

            leaf = parts.reduce(root_node) do |parent_s_node,slug|
              Synergy::Node.find_or_create_by!(source_name: source_name, parent: parent_s_node, slug: slug)
            end

            leaf.content    = node_data[:content]
            leaf.title      = node_data[:title]
            leaf.source_url = node_data[:source_url]
            leaf.save!
          end
        end
      end
    end
  end
end
