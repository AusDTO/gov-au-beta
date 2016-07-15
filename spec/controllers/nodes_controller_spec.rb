require 'rails_helper'

RSpec.describe NodesController, :type => :controller do
  describe 'GET #show' do
    let!(:root_node) { Fabricate(:root_node) }

    describe 'finding a node' do
      let(:foo) { Fabricate(:section, name: 'foo')}
      let(:zero) { Fabricate(:node, name: 'zero', section: foo) }

      %w(one two).each do |num|
        let!(num.to_sym) { Fabricate(:node, name: num, section: foo) }
      end

      %w(three four).each do |num|
        let!(num.to_sym) { Fabricate(:node, name: num, section: foo, parent: zero)}
      end

      %w(five six).each do |num|
        let!(num.to_sym) { Fabricate(:node, name: num, section: foo, parent: four)}
      end

      context 'given a non-existing path' do
        it 'should throw a not found' do
          expect {
            get :show, params: { path: '/rubbish' }
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'given a page with a valid parent' do
        it 'should return the page successfully' do
          get :show, params: { path: 'foo/zero/three' }
          expect(response.status).to eq(200)
        end
      end

      context 'given a page nested beneath another page' do
        it 'should return the page successfully' do
          get :show, params: { path: 'foo/zero/four/six' }
          expect(response.status).to eq(200)
        end
      end

      context 'given a non-existing page in a valid route' do
        it 'should throw a not found' do
          expect {
            get :show, params: { path: 'foo/zero/four/six/eight' }
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context 'given an existing page with wrong base path' do
        it 'should throw a not found' do
          expect {
            get :show, params: { path: 'silly/zero' }
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end
    end

    describe 'layout' do
      let(:node) { Fabricate(:node, section: section) }
      subject { get :show, params: { path: node.path} }

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
      let(:node) { Fabricate(:node, parent: root_node, state: state) }

      let(:request) {
        get :show, params: { path: node.path}
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

      let(:node) { Fabricate(:node, parent: root_node, state: state) }

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
