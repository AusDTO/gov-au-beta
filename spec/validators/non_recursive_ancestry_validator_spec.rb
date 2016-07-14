require 'rails_helper'

class Validatable
  include ActiveModel::Validations
  attr_accessor :parent
  validates_with NonRecursiveAncestryValidator

  def initialize(parent)
    @parent = parent
  end
end

describe NonRecursiveAncestryValidator do
  let(:parent) { Validatable.new nil }
  subject { Validatable.new parent }

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
