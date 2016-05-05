require 'rails_helper'
describe 'Node Creation' do
  context 'when given a valid node id' do
    it 'should create a node in this system' do
      stub_request(:get, "www.example.com/api/node/1")
          .to_return(:headers =>{"Content-Type" => "application/json"},
                     :body => File.read(File.join("spec", "fixtures", "drupal_node.json")))
      NodeCreateJob.perform_now "1"
      expect(Node.find_by(name: "My page")).to be_present
    end
    it 'should update a node in this system' do
      Node.create(:name => "My page", :content_block => ContentBlock.new(:body => "old body"))
      stub_request(:get, "www.example.com/api/node/1")
          .to_return(:headers =>{"Content-Type" => "application/json"},
                     :body => File.read(File.join("spec", "fixtures", "drupal_node.json")))
      NodeCreateJob.perform_now "1"
      expect(Node.find_by(name: "My page")).to be_present
      expect(Node.find_by(name: "My page").content_block.body).to eq("<p>page</p>")
    end
  end
  context 'when given a system error' do
    it 'should not create a node in this system' do
      stub_request(:get, "http://www.example.com/api/node/2").
          to_return(:status => 500, :body => "System error", :headers => {})
      NodeCreateJob.perform_now "2"
      expect(Node.first).to eq(nil)
    end
  end
  context 'when given a missing node id' do
    it 'should not create a node in this system' do
      stub_request(:get, "http://www.example.com/api/node/3").
          to_return(:status => 404, :body => "Not found", :headers => {})
      NodeCreateJob.perform_now "3"
      expect(Node.first).to eq(nil)
    end
  end
end