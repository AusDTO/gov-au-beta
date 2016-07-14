require 'rails_helper'

class AncestryDepthValidatable
  include ActiveModel::Validations
  attr_reader :parent

  def initialize(parent)
    @parent = parent
  end
end

class MinimumOne < AncestryDepthValidatable
  validates :parent, ancestry_depth: { minimum: 1 }
end

class MaximumOne < AncestryDepthValidatable
  validates :parent, ancestry_depth: { maximum: 1 }
end

class EqualsOne < AncestryDepthValidatable
  validates :parent, ancestry_depth: { equals: 1 }
end

class RangeOneToTwo < AncestryDepthValidatable
  validates :parent, ancestry_depth: { minimum: 1, maximum: 2 }
end

describe AncestryDepthValidator do
  let(:orphan) { clazz.new nil }
  let(:child) { clazz.new orphan }
  let(:grandchild) { clazz.new child }
  let(:greatgrandchild) { clazz.new grandchild }

  context 'depth minimum one' do
    let(:clazz) { MinimumOne }

    context 'orphan' do
      subject { orphan }
      it { is_expected.not_to be_valid }
    end

    context 'child' do
      subject { child }
      it { is_expected.to be_valid }
    end
  end

  context 'depth maximum one' do
    let(:clazz) { MaximumOne }

    context 'child' do
      subject { child }
      it { is_expected.to be_valid }
    end

    context 'grandchild' do
      subject { grandchild }
      it { is_expected.not_to be_valid }
    end
  end

  context 'depth equals one' do
    let(:clazz) { EqualsOne }

    context 'orphan' do
      subject { orphan }
      it { is_expected.not_to be_valid }
    end

    context 'child' do
      subject { child }
      it { is_expected.to be_valid }
    end

    context 'grandchild' do
      subject { grandchild }
      it { is_expected.not_to be_valid }
    end
  end

  context 'range of one to two' do
    let(:clazz) { RangeOneToTwo }

    context 'orphan' do
      subject { orphan }
      it { is_expected.not_to be_valid }
    end

    context 'child' do
      subject { child }
      it { is_expected.to be_valid }
    end

    context 'grandchild' do
      subject { grandchild }
      it { is_expected.to be_valid }
    end

    context 'greatgrandchild' do
      subject { greatgrandchild }
      it { is_expected.not_to be_valid }
    end
  end
end
