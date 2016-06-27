require 'rails_helper'
require 'pry'

require 'synergy/cms_import'

RSpec.describe Synergy::CMSImport, :type => :cms_import do

  class DummyCMSAdapter
    attr_reader :section

    def initialize(section)
      @section = section
    end

    def dummy_nodes=(nodes)
      @dummy_nodes = nodes
    end

    def run(&block)
      @dummy_nodes.each{|node| yield node}
    end

    def destination_path
      "/#{section.slug}"
    end

    def log(message); end
  end

  before(:each) do
    SynergyNode.delete_all
  end

  after(:each) do
    SynergyNode.delete_all
  end

  let(:cms_url)               { "http://foo.bar.com/stuff" }
  let(:section)           { Fabricate(:section, :cms_url => cms_url) }
  let(:adapter)           do
    adapter = DummyCMSAdapter.new(section)
    adapter.dummy_nodes = dummy_nodes
    adapter
  end
  let(:importer)          { Synergy::CMSImport.new(adapter) }
  let(:root_node)         { Fabricate(:synergy_node, path: '/', source_name: 'synergy') }
  let(:dummy_nodes) do
    [
      { 
        source_url: "http://foo.bar.com/stuff/dummy.html",
        path: "dummy",
        title: "Hello from Dummy",
        content: "test content"
      }
    ]
  end

  describe "database transactions" do

    let(:dummy_nodes) { [] }

    before do
      Fabricate(:synergy_node, source_name: section.slug, parent: root_node)
    end


    it "all nodes for a source are replaced during import" do
      expect(SynergyNode.where(source_name: section.slug).count).to eq(1)
      importer.run
      expect(SynergyNode.where(source_name: section.slug).count).to eq(0)
    end

  end

  describe "pending..." do

    it 'creates nodes off the synergy root node'
    it 'recreates the full path of the source node'
    it 'sets the source url of every node in the path'
    it 'sets the content of the leaf node'
    it 'sets the title of the leaf node'

  end

end

