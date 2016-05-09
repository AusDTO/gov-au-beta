require 'rails_helper'

RSpec.describe Node, type: :model do

  it { should belong_to :section }
  it { should belong_to :parent }
  it { should have_many :children }
  it { should have_one :content_block }
  it { should validate_uniqueness_of(:order_num).scoped_to(:parent_id) }

  describe 'Sibling order' do

    let(:root) { Fabricate(:node) }

    %w(zero one two three four five).each_with_index do |num, idx|
      let(num.to_sym) { Fabricate(:node, parent: root, order_num: idx) }
    end

    it 'should find the siblings in the right order' do
      # n.b. lets are lazy
      [five, two, one, zero, three, four]
      root.children.should eq [zero, one, two, three, four, five]
    end

    let(:new_one) { Fabricate(:node, parent: root ) } # No explicit order num

    it 'should automatically set an order number if necessary' do
      [one, two, three, new_one]
      new_one.order_num.should eq 4
    end

  end

end
