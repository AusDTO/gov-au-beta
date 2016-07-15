require 'rails_helper'

class RootProtectionValidatable
  include ActiveModel::Validations
  validates_with RootProtectionValidator
  attr_reader :parent

  def initialize(parent)
    @parent = parent
  end
end

describe RootProtectionValidator do
  subject { RootProtectionValidatable.new parent }

  context 'A root node exists' do
    let!(:root_node) { Fabricate(:root_node) }

    context 'with a parent' do
      let(:parent) { 'something' }
      it { is_expected.to be_valid }
    end

    context 'without a parent' do
      let(:parent) { nil }
      it { is_expected.not_to be_valid }
    end
  end

  context 'No root node exists' do
    context 'with a parent' do
      let(:parent) { 'something' }
      it { is_expected.to be_valid }
    end

    context 'without a parent' do
      let(:parent) { nil }
      it { is_expected.to be_valid }
    end
  end
end
