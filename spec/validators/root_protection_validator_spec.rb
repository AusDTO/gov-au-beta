require 'rails_helper'

class RootProtectionValidatable
  include ActiveModel::Validations
  validates_with RootProtectionValidator
  attr_reader :type

  def initialize(type)
    @type = type
  end
end

describe RootProtectionValidator do
  subject { RootProtectionValidatable.new type }

  context 'A root node exists' do
    let!(:root_node) { Fabricate(:root_node) }

    context 'with a root node' do
      let(:type) { 'RootNode' }
      it { is_expected.not_to be_valid }
    end

    context 'without a root node' do
      let(:type) { 'something' }
      it { is_expected.to be_valid }
    end
  end

  context 'No root node exists' do
    context 'with a root node' do
      let(:type) { 'RootNode' }
      it { is_expected.to be_valid }
    end

    context 'without a parent' do
      let(:type) { nil }
      it { is_expected.to be_valid }
    end
  end
end
