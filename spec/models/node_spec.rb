require 'rails_helper'

RSpec.describe Node, type: :model do
  include ::NodesHelper

  it { is_expected.to belong_to :section }
  it { is_expected.to belong_to :parent }
  it { is_expected.to have_many :children }
  let!(:root_node) { Fabricate(:root_node) }

  describe 'Sibling order' do
    %w(zero one two three four five).each_with_index do |num, idx|
      let(num.to_sym) { Fabricate(:node, section: nil, parent: root_node,
        order_num: idx) }
    end

    it 'should find the siblings in the right order' do
      # n.b. lets are lazy
      [five, two, one, zero, three, four]
      expect(root_node.children).to eq [zero, one, two, three, four, five]
    end

    let(:new_one) { Fabricate(:node, section: nil, parent: root_node ) } # No explicit order num

    it 'should automatically set an order number if necessary' do
      [one, two, three, new_one]
      expect(new_one.order_num).to eq 4
    end
  end

  describe 'ancestry' do
    let!(:alpha) { Fabricate(:node, name: 'alpha', parent: root_node) }
    let(:beta) { Fabricate(:node, name: 'beta', parent: alpha) }
    let(:gamma) { Fabricate(:node, name: 'gamma', parent: beta) }

    describe 'path' do
      subject { node.path }

      context 'for top level node' do
        let(:node) { alpha }
        it { is_expected.to eq 'alpha' }
      end

      context 'for second level node' do
        let(:node) { beta }
        it { is_expected.to eq 'alpha/beta' }
      end

      context 'for third level node' do
        let(:node) { gamma }
        it { is_expected.to eq 'alpha/beta/gamma' }
      end
    end
  end

  describe 'state' do
    it { is_expected.to validate_inclusion_of(:state).in_array(
      %w(draft published))}

    let(:draft_node) { Fabricate(:node, parent: root_node, state: 'draft') }
    let(:published_node) { Fabricate(:node, parent: root_node, state: 'published')}

    context 'draft scope' do
      subject { Node.with_state :draft }

      it { is_expected.to include draft_node }
      it { is_expected.not_to include published_node }
    end

    context 'published scope' do
      subject { Node.with_state :published }

      it { is_expected.not_to include draft_node }
      it { is_expected.to include published_node }
    end

    context 'without scope' do
      subject { Node.all }

      it { is_expected.to include draft_node }
      it { is_expected.to include published_node }
    end

    context 'combined draft and published scope' do
      subject { Node.with_state :draft, :published }

      it { is_expected.to include draft_node }
      it { is_expected.to include published_node }
    end
  end

  describe '#token' do
    it { is_expected.to validate_uniqueness_of(:token) }

    subject { Fabricate(:node, parent: root_node, token: nil) }

    it 'automatically populates a token' do
      expect(subject.token).to be_present
    end
  end

  describe 'creation of a node with content' do
    let(:node) { Fabricate(:node, parent: root_node, content_body: 'foo') }

    it 'has an automatically generated revision' do
      expect(node.revisions.count).to eq 1
    end
  end

  describe '#revise' do
    let(:node) { Fabricate(:node, parent: root_node, content_body: 'foo') }

    subject { node.revise!(content_body: 'foo bar').diffs }

    it do
      is_expected.to eq({
        'content_body' => Class.new.extend(Revisable).persistable_diff(
          'foo', 'foo bar'
        ).to_json
      })
    end
  end

  describe 'slugs' do
    let!(:parent) { Fabricate(:node, parent: root_node, name: 'foo') }
    let!(:child1) { Fabricate(:node, parent: parent, name: 'foo') }
    let!(:child2) { Fabricate(:node, parent: parent, name: 'foo') }
    let!(:other) { Fabricate(:node, parent: root_node, name: 'not a clash') }

    it 'can be the same as a node with a different parent' do
      expect(parent.slug).to eq(child1.slug)
    end

    it 'are unique within a parent' do
      expect(child1.slug).not_to eq(child2.slug)
    end

    context 'update' do
      it 'when the name is changed' do
        expect(child1.slug).to eq('foo')
        child1.update(name: 'bar')
        expect(child1.slug).to eq('bar')
      end

      it 'when the parent is changed' do
        expect(child2.slug).to match('foo-')
        child2.update(parent: other)
        expect(child2.slug).to eq('foo')
      end
    end
  end

  describe '#with_name' do
    let!(:node1) { Fabricate(:node, name: 'one') }
    let!(:node2) { Fabricate(:node, name: 'two') }
    let!(:node3) { Fabricate(:node, name: 'two') }

    it 'returns one element if name is unique' do
      expect(Node.with_name('one')).to match_array([node1])
    end

    it 'returns all elements if name is not unique' do
      expect(Node.with_name('two')).to match_array([node2, node3])
    end

    it 'returns no elements if name is unknown' do
      expect(Node.with_name('three')).to match_array([])
    end
  end

  describe 'full path' do
    let!(:article) { Fabricate(:news_article) }
    let!(:node) { Fabricate(:node) }

    context 'for a news article' do
      it 'matches its url helper' do
        expect(public_node_path(article)).to eq(Rails.application.routes.url_helpers.news_article_path(
          article.section.home_node.slug, article.slug
        ))
      end
    end

    context 'for a general node' do
      it 'matches its url helper' do
        expect(public_node_path(node)).to eq(Rails.application.routes.url_helpers.nodes_path(node.path))
      end
    end
  end
end
