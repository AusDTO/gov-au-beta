require 'rails_helper'

class NonRecursiveAncestryValidatable
  include ActiveModel::Validations
  attr_accessor :parent
  validates :parent, non_recursive_ancestry: true

  def initialize(parent)
    @parent = parent
  end
end

describe NonRecursiveAncestryValidator do
  let(:parent) { NonRecursiveAncestryValidatable.new nil }
  subject { NonRecursiveAncestryValidatable.new parent }

  context 'sensible ancestry' do
    it { is_expected.to be_valid }
  end

  context 'circular ancestry' do
    before do
      parent.parent = subject
    end

    it { is_expected.not_to be_valid }
  end
end
