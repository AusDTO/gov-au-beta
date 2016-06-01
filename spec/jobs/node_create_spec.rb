require 'rails_helper'
describe 'Node Creation' do
  let!(:root) { Fabricate(:section, name: 'root', id: 1)}
  let!(:parent) { Fabricate(:node, :name => "Parent page", :uuid => "parent")}

  def drupal_node
    return File.read(File.join('spec', 'fixtures', 'drupal_node.json'))
  end

  def authoring_url
    return Rails.application.config.authoring_base_url
  end

  def cas_url
    return Rails.application.config.content_analysis_base_url
  end

  before(:each) do
    stub_request(:get, authoring_url + '/api/node/1/1')
        .to_return(:headers => {'Content-Type' => 'application/json'},
                   :body => drupal_node)
    stub_request(:post, Regexp.new(authoring_url + '/api/node/result/\d+/1'))
        .to_return(:headers => {'Content-Type' => 'application/json'},
                   :body => '{"new_state" : "published"}')
    stub_request(:post, cas_url + '/api/linters')
        .with(body: /assist/)
        .to_return(:headers => {'Content-Type' => 'application/json'},
                   :body => '{"assist" : "help"}')
    stub_request(:post, cas_url + '/api/linters')
        .with(body: /unparseable/)
        .to_return(status: 500)
    stub_request(:post, cas_url + '/api/linters')
        .with { |request| request.body !~ /(assist|unparseable)/ }
        .to_return(:headers => {'Content-Type' => 'application/json'},
                   :body => '{}')
  end

  context 'when given a valid node id for a new node' do

    it 'should create a node in this system' do
      NodeCreateJob.perform_now "1", "1"
      expect(Node.find_by(name: "My page")).to be_present
      expect(Node.find_by(name: "My page").template).to eq("default")
      expect(Node.find_by(name: "My page").section).to eq(root)
      expect(Node.find_by(name: "My page").parent).to eq(parent)
    end
  end
  context 'when given a valid node id but parent is missing' do
    let!(:parent) { Fabricate(:node, :name => "Parent page", :uuid => "notparent")}
    it 'should return an error' do
      expect {NodeCreateJob.perform_now "1", "1"}.to raise_error
      expect(Node.second).to eq(nil)
    end
  end
  context 'when given a valid node id for an node' do
    let!(:existing_node) { Fabricate(:node, :name => "My page", :uuid => "9a1f4ffe-3f8b-4e0e-b6e0-1c58ffa6efb4",
                                     :content_block => ContentBlock.new(:body => "old body", :unique_id => "9a1f4ffe-3f8b-4e0e-b6e0-1c58ffa6efb4_body"))}
    it 'should update a node in this system' do
      NodeCreateJob.perform_now "1", "1"
      expect(Node.find_by(name: "My page")).to be_present
      expect(Node.find_by(name: "My page").content_block.body).to eq("<p>page</p>")
    end
  end
  context 'when given a system error when getting a node' do
    it 'should not create a node in this system' do
      stub_request(:get, authoring_url + '/api/node/2/1').
          to_return(:status => 500, :body => "System error", :headers => {})
      expect {NodeCreateJob.perform_now "2", "1"}.to raise_error
      expect(Node.second).to eq(nil)
    end
  end
  context 'when given a system error when posting a result' do
    it 'should create a node in this system' do
      stub_request(:get, authoring_url + '/api/node/1/2')
          .to_return(:headers => {'Content-Type' => 'application/json'},
                     :body => drupal_node)
      stub_request(:post, authoring_url + '/api/node/result/1/2').
          to_return(:status => 500, :body => 'System error', :headers => {})
      expect { NodeCreateJob.perform_now '1', '2' }.to raise_error
      expect(Node.find_by(name: 'My page')).to be_present
    end
  end

  context 'when given a missing node id' do
    it 'should not create a node in this system' do
      stub_request(:get, authoring_url + '/api/node/3/1').
          to_return(:status => 404, :body => "Not found", :headers => {})
      expect {NodeCreateJob.perform_now "3", "1"}.to raise_error
      expect(Node.second).to eq(nil)
    end
  end

  context 'when given an incorrect template' do
    it 'should create a node with a default template' do
      body = JSON.load(drupal_node)
      body['field_template']['und'][0]['value'] = 'note-a-template'
      stub_request(:get, authoring_url + '/api/node/1/1')
          .to_return(:headers =>{'Content-Type' => 'application/json'},
                     :body => JSON.dump(body))
      NodeCreateJob.perform_now '1', '1'
      expect(Node.find_by(name: 'My page')).to be_present
      expect(Node.find_by(name: 'My page').template).to eq('default')
    end
  end

  context 'when given a node with no parent' do
    it 'should create a node with no parent' do
      body = JSON.load(drupal_node)
      body['field_parent'] = nil
      stub_request(:get, authoring_url + '/api/node/2/1')
          .to_return(:headers => {'Content-Type' => 'application/json'},
                     :body => JSON.dump(body))
      NodeCreateJob.perform_now '2', '1'
      expect(Node.find_by(name: 'My page')).to be_present
      expect(Node.find_by(name: 'My page').parent_id).to be_nil
    end
  end

  context 'when given a node with no section' do
    it 'should give an error' do
      body = JSON.load(drupal_node)
      body['field_section'] = nil
      stub_request(:get, authoring_url + '/api/node/2/1')
          .to_return(:headers => {'Content-Type' => 'application/json'},
                     :body => JSON.dump(body))
      expect { NodeCreateJob.perform_now '2', '1' }.to raise_error
      expect(Node.find_by(name: 'My page')).not_to be_present
    end
  end

  context 'when given a node with no section' do
    it 'should give an error' do
      body = JSON.load(drupal_node)
      body['field_section'] = nil
      stub_request(:get, authoring_url + '/api/node/2/1')
          .to_return(:headers => {'Content-Type' => 'application/json'},
                     :body => JSON.dump(body))
      expect { NodeCreateJob.perform_now '2', '1' }.to raise_error
      expect(Node.find_by(name: 'My page')).not_to be_present
    end
  end

  context 'when given bad content' do
    it 'should give an error' do
      body = JSON.load(drupal_node)
      body['body']['und'][0]['value'] = '<p>assist is too complex</p>'
      stub_request(:get, authoring_url + '/api/node/2/1')
          .to_return(:headers => {'Content-Type' => 'application/json'},
                     :body => JSON.dump(body))
      expect { NodeCreateJob.perform_now '2', '1' }.to raise_error
      expect(Node.find_by(name: 'My page')).not_to be_present
    end
  end

  context 'when content analysis gives a system error' do
    it 'should give an error' do
      body = JSON.load(drupal_node)
      body['body']['und'][0]['value'] = '<p>unparseable</p>'
      stub_request(:get, authoring_url + '/api/node/2/1')
          .to_return(:headers => {'Content-Type' => 'application/json'},
                     :body => JSON.dump(body))
      expect { NodeCreateJob.perform_now '2', '1' }.to raise_error
      expect(Node.find_by(name: 'My page')).not_to be_present
    end
  end

end