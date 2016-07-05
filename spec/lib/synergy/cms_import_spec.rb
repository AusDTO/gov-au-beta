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

  let!(:root_node) { Fabricate(:root_node) }

  before(:each) do
    Node.where(section: section).delete_all
  end

  after(:each) do
    Node.where(section: section).delete_all
  end

  let(:cms_url)           { "http://foo.bar.com/stuff" }
  let(:section)           { Fabricate(:section, :cms_url => cms_url) }
  let(:adapter)           do
    DummyCMSAdapter.new(section).tap do |adapter|
      adapter.dummy_nodes = dummy_nodes
    end
  end
  let(:importer)          { Synergy::CMSImport.new(adapter) }
  let(:dummy_nodes) do
    [
      {
        cms_ref: "http://foo.bar.com/stuff/dummy1.html",
        path: "dummy1",
        title: "Hello from Dummy1",
        content: "test content"
      },
      {
        cms_ref: "http://foo.bar.com/stuff/dummy2.html",
        path: "dummy2",
        title: "Hello from Dummy2",
        content: "test content"
      },
    ]
  end

  describe "running the importer" do
    before(:each) { importer.run }
    let(:nodes)   { Node.where(section: section).all }

    it "should create a synergy node for every node produced by the adapter" do
      expect(nodes.collect(&:name)).to include('Hello from Dummy1', 'Hello from Dummy2')
    end
    it "should create a synergy node for the section landing page" do
      expect(nodes.count).to eq(dummy_nodes.count + 1)
    end
  end

  describe "database transactions" do
    let(:dummy_nodes) { [] }

    before(:each) do
      Fabricate(:node, section: section, parent: root_node)
    end

    it "all nodes for a source are replaced during import" do
      expect(Node.where(section: section).count).to eq(1)
      importer.run
      expect(Node.where(section: section).count).to eq(0)
    end
  end
end
