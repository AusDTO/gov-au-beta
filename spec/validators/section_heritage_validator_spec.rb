require 'rails_helper'

class SectionHeritageValidatable
  include ActiveModel::Validations
  validates_with SectionHeritageValidator
  attr_reader :section
  attr_reader :parent

  def initialize(section, parent=nil)
    @section = section
    @parent = parent
  end
end

describe SectionHeritageValidator do
  let(:parent_section) { 'abc' }
  subject { SectionHeritageValidatable.new section, parent }

  context 'with a parent' do
    let(:parent) { SectionHeritageValidatable.new parent_section }

    context 'section matches parent\'s section' do
      let(:section) { parent_section }
      it { is_expected.to be_valid }
    end

    context 'section different from parent\'s section' do
      let(:section) { 'xyz' }
      it { is_expected.not_to be_valid }
    end
  end

  context 'without a parent' do
    let(:parent) { nil }
    let(:section) { 'anything' }
    it { is_expected.to be_valid }
  end
end
