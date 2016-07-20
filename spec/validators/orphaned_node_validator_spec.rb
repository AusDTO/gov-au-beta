require 'rails_helper'

class OrphanedNodeValidatable
  include ActiveModel::Validations
  validates_with OrphanedNodeValidator
  attr_reader :parent

  def initialize(parent)
    @parent = parent
  end
end

describe OrphanedNodeValidator do
  subject { OrphanedNodeValidatable.new parent }

  context 'with a parent' do
    let(:parent) { 'something' }
    it { is_expected.to be_valid }
  end

  context 'without a parent' do
    let(:parent) { nil }
    it { is_expected.not_to be_valid }
  end
end