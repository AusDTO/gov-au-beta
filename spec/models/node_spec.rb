require 'rails_helper'

RSpec.describe Node, type: :model do
  it { is_expected.to belong_to :section }
  it { is_expected.to belong_to :parent }
  it { is_expected.to have_many :children }
  let!(:root_node) { Fabricate(:root_node) }

  describe 'Sibling order' do
    %w(zero one two three four five).each_with_index do |num, idx|
      let(num.to_sym) { Fabricate(:node, parent: root_node, order_num: idx) }
    end

    it 'should find the siblings in the right order' do
      # n.b. lets are lazy
      [five, two, one, zero, three, four]
      expect(root_node.children).to eq [zero, one, two, three, four, five]
    end

    let(:new_one) { Fabricate(:node, parent: root_node ) } # No explicit order num

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

    describe 'section inheritance' do
      it 'is expected to inherit its section from its parent' do
        expect(gamma.section).to eq beta.section
      end
    end

    describe 'validations' do
      describe 'root node protection' do
        subject { Fabricate.build(:root_node) }
        it { should_not be_valid }
      end

      describe 'section home protection' do
        subject { node = Fabricate.build(:node, parent: root_node,
          section: alpha.section) }
        it { should_not be_valid }
      end

      describe 'section heritage' do
        subject { Fabricate.build(:node, parent: beta,
          section: Fabricate(:section)) }
        it { should_not be_valid }
      end

      describe 'section presence' do
        subject {
          # Have to do this manually as fabricator adds a section by default
          node = Fabricate.build(:node, parent: root_node)
          node.section = nil
          node }

        it { should_not be_valid }
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
end
