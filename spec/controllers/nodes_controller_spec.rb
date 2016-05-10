require 'rails_helper'

RSpec.describe NodesController, :type => :controller do
  describe 'GET #show' do

    describe 'finding a node' do    
      render_views  

      let (:root) { Fabricate(:section, name: "root")}
      let (:zero) { Fabricate(:node, name: "zero", section: root) }

      %w(one two).each do |num|
        let!(num.to_sym) { Fabricate(:node, name: num, section: root) }
      end

      %w(three four).each do |num|
        let!(num.to_sym) { Fabricate(:node, name: num, section: root, parent: zero)}
      end

      %w(five six).each do |num|
        let!(num.to_sym) { Fabricate(:node, name: num, section: root, parent: four)}
      end

      context "given a non-existing section" do
        it "should throw a not found" do
          expect {
            get :show, params: {:section => "no-section"}
          }.to raise_error ActiveRecord::RecordNotFound
        end

        context "given some path beneath a non-existing section" do
          it "should throw a not found" do
            expect {
              get :show, params: {:section => "no-section", path: "some-path"}
            }.to raise_error ActiveRecord::RecordNotFound
          end
        end
      end

      context "given an existing node with a valid section" do
        it "should return the page successfully" do
          get :show, params: {:section => "root", path: "one"}
          expect(response.status).to eq(200)
        end
      end

      context "given a non-existing node beneath a valid section" do
        it "should throw a not found" do
          expect {
            get :show, params: {:section => "root", path: "not-existing"}
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context "given a page with a valid parent" do
        it "should return the page successfully" do
          get :show, params: {:section => "root", path: "zero/three"}
          expect(response.status).to eq(200)
        end
      end

      context "given a page nested beneath another page" do
        it "should return the page successfully" do
          get :show, params: {:section => "root", path: "zero/four/six"}
          expect(response.status).to eq(200)
        end
      end

      context "given a non-existing page in a valid route" do
        it "should throw a not found" do
          expect {
            get :show, params: {:section => "root", path: "zero/four/six/eight"}
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context "given an existing page beneath a non-existing section" do
        it "should throw a not found" do
          expect {
            get :show, params: {:section => "bad-section", path: "zero"}
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    describe 'layout' do 
      let(:node) { Fabricate(:node, section: section) }
      subject { get :show, params: {section: section.slug, path: node.path} }

      context 'with a custom layout' do 
        let(:section) { Fabricate(:section, layout: 'communications')}

        it 'should use the custom layout' do 
          expect(subject).to render_template 'layouts/communications'
        end
      end

      context 'with a custom layout' do 
        let(:section) { Fabricate(:section)}

        it 'should not use the custom layout' do 
          expect(subject).not_to render_template 'layouts/communications'
        end
      end
    end

    describe 'content block compiling' do

      let(:root) { Fabricate(:section, name: "root")}
      let!(:node) { Fabricate(:node, name: "nodeA", uuid:"uuid_nodeA", section: root) }

      context 'with a uuid link' do
        let(:linking_content) { Fabricate(:content_block, unique_id: "uuid_cb", body: '<a href="/invalid" data-uuid="uuid_nodeA">My link</a>')}
        let!(:linking_node) { Fabricate(:node, name: "nodeB", uuid:"uuid_nodeB", section: root, content_block: linking_content) }

        it 'should render the link' do
          get :show, params: {:section => "root", path: "nodeb"}
          expect(response.status).to eq(200)
        end
      end


    end
  end
end