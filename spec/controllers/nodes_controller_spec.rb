require 'rails_helper'

RSpec.describe NodesController, :type => :controller do
  describe 'GET #show' do

    describe 'finding a node' do
      render_views  

      let(:root) { Fabricate(:section, name: "root")}
      let(:zero) { Fabricate(:node, name: "zero", section: root) }

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
          get :show, params: { section: "root", path: "one" }
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

        it { is_expected.to render_with_layout 'communications'}
      end

      context 'without a custom layout' do
        let(:section) { Fabricate(:section)}

        it { is_expected.not_to render_with_layout 'communications' }
      end
    end

    describe 'node state' do
      let(:node) { Fabricate(:node, state: state) }

      let(:request) {
        get :show, params: { section: node.section.slug, path: node.path}
      }

      context 'published node' do
        let(:state) { 'published' }

        it 'shows the node' do
          request
          expect(response.status).to eq(200)
        end
      end

      context 'draft node' do
        let(:state) { 'draft' }

        it 'throws an error' do
          expect { request }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    describe 'previews' do    
      shared_examples_for 'node preview' do
        it { is_expected.to assign_to(:node).with node }
        it { is_expected.to render_with_layout node.section.layout }
      end

      let(:node) { Fabricate(:node, state: state) }

      before do
        get :preview, params: { token: node.token}
      end

      context 'published node' do
        let(:state) { 'published' }
        include_examples 'node preview'
      end

      context 'draft node' do
        let(:state) { 'draft' }
        include_examples 'node preview'
      end
    end
  end
end
