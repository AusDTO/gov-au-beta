require 'rails_helper'

RSpec.describe Node, type: :model do
  include ::NodesHelper

  it { is_expected.to belong_to :section }
  it { is_expected.to belong_to :parent }
  it { is_expected.to have_many :children }
  let!(:root_node) { Fabricate(:root_node) }
  let!(:section) { Fabricate(:section, name: "tango") }
  let!(:section_home) { Fabricate(:section_home, section: section) }

  describe "modifications" do
    let(:node) { Fabricate(:general_content, parent: section_home, content_body: 'foo') }
    it "records log messages" do
      expect(Rails.logger).to receive(:info).with(/event=update_record/).at_least(:once)
      expect(Rails.logger).to receive(:info).with(/event=create_record/).at_least(:once)
      node.name = "NewName"
      node.save!
    end
  end

  describe 'Sibling order' do
    %w(zero one two three four five).each_with_index do |num, idx|
      let(num.to_sym) { Fabricate(:general_content, parent: section_home, order_num: idx) }
    end

    it 'should find the siblings in the right order' do
      # n.b. lets are lazy
      [five, two, one, zero, three, four]
      expect(section_home.children).to eq [zero, one, two, three, four, five]
    end

    let(:new_one) { Fabricate(:general_content, parent: section_home ) } # No explicit order num

    it 'should automatically set an order number if necessary' do
      [one, two, three, new_one]
      expect(new_one.order_num).to eq 4
    end
  end

  describe 'ancestry' do
    let!(:alpha) { Fabricate(:general_content, name: 'alpha', parent: section_home) }
    let(:beta) { Fabricate(:general_content, name: 'beta', parent: alpha) }
    let(:gamma) { Fabricate(:general_content, name: 'gamma', parent: beta) }

    describe 'path' do
      subject { node.path }

      context 'for top level node' do
        let(:node) { alpha }
        it { is_expected.to eq 'tango/alpha' }
      end

      context 'for second level node' do
        let(:node) { beta }
        it { is_expected.to eq 'tango/alpha/beta' }
      end

      context 'for third level node' do
        let(:node) { gamma }
        it { is_expected.to eq 'tango/alpha/beta/gamma' }
      end
    end
  end

  describe 'state' do
    it { is_expected.to validate_inclusion_of(:state).in_array(
      %w(draft published))}

    let(:draft_node) { Fabricate(:general_content, parent: section_home, state: 'draft') }
    let(:published_node) { Fabricate(:general_content, parent: section_home, state: 'published')}

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

    subject { Fabricate(:general_content, parent: section_home, token: nil) }

    it 'automatically populates a token' do
      expect(subject.token).to be_present
    end
  end

  describe 'creation of a node with content' do
    let(:node) { Fabricate(:general_content, parent: section_home, content_body: 'foo') }

    it 'has an automatically generated revision' do
      expect(node.revisions.count).to eq 1
    end
  end

  describe '#revise' do
    let(:node) { Fabricate(:general_content, parent: section_home, content_body: 'foo') }

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
    let!(:parent) { Fabricate(:general_content, parent: section_home, name: 'foo') }
    let!(:child1) { Fabricate(:general_content, parent: parent, name: 'foo') }
    let!(:child2) { Fabricate(:general_content, parent: parent, name: 'foo') }
    let!(:other) { Fabricate(:general_content, parent: section_home, name: 'not a clash') }

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
    let!(:node1) { Fabricate(:general_content, parent: section_home, name: 'one') }
    let!(:node2) { Fabricate(:general_content, parent: section_home, name: 'two') }
    let!(:node3) { Fabricate(:general_content, parent: section_home, name: 'two') }

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
    let!(:article) { Fabricate(:news_article, parent: section_home) }
    let!(:node) { Fabricate(:general_content) }

    context 'for a news article' do
      it 'matches its url helper' do
        expect(public_node_path(article)).to eq(Rails.application.routes.url_helpers.news_article_path(
          article.section.slug, article.slug
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
