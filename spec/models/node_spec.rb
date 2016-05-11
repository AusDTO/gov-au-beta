require 'rails_helper'

RSpec.describe Node, type: :model do

  it { should belong_to :section }
  it { should belong_to :parent }
  it { should have_many :children }
  it { should have_one :content_block }
  describe "ordering" do
    subject { Fabricate(:node, uuid: "root") }
    it { should validate_uniqueness_of(:order_num).scoped_to(:parent_id) }
  end

  describe 'Sibling order' do

    let(:root) { Fabricate(:node, uuid: "root") }

    %w(zero one two three four five).each_with_index do |num, idx|
      let(num.to_sym) { Fabricate(:node, uuid: "uuid_#{num}", parent: root, order_num: idx) }
    end

    it 'should find the siblings in the right order' do
      # n.b. lets are lazy
      [five, two, one, zero, three, four]
      root.children.should eq [zero, one, two, three, four, five]
    end

    let(:new_one) { Fabricate(:node, uuid: "uuid_new_one", parent: root ) } # No explicit order num

    it 'should automatically set an order number if necessary' do
      [one, two, three, new_one]
      new_one.order_num.should eq 4
    end
  end

  describe 'ancestry' do

    let(:alpha) { Fabricate(:node, name: 'alpha') }
    let(:beta) { Fabricate(:node, name: 'beta', parent: alpha) }
    let(:gamma) { Fabricate(:node, name: 'gamma', parent: beta) }

    it 'should know its ancestry' do
      expect(gamma.ancestry).to eq [gamma, beta, alpha]
    end

    describe 'path' do

      subject { node.path }

      context 'for top level node' do
        let(:node) { alpha }

        it { should eq 'alpha' }
      end

      context 'for second level node' do 
        let(:node) { beta }

        it { should eq 'alpha/beta' }
      end

      context 'for third level node' do
        let(:node) { gamma }

        it { should eq 'alpha/beta/gamma' }
      end
    end
  end
end
