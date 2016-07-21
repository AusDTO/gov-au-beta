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

  context 'with an existing root node' do
    let!(:root_node) { Fabricate(:root_node) }

    context 'creating a new root node' do
      let(:type) { 'RootNode' }
      it { is_expected.not_to be_valid }
    end

    context 'creating a non-root node' do
      let(:type) { 'something' }
      it { is_expected.to be_valid }
    end
  end

  context 'without an existing root node' do
    context 'creating a root node' do
      let(:type) { 'RootNode' }
      it { is_expected.to be_valid }
    end

    context 'creating a non-root node' do
      let(:type) { 'something' }
      it { is_expected.to be_valid }
    end
  end
end
