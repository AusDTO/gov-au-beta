require 'rails_helper'

class MyNode
  include ActiveModel::Validations
  include ActiveModel::Validations::Callbacks
  include SectionHeritage

  attr_accessor :section
  attr_accessor :parent

  def initialize(section: nil, parent: nil)
    @section = section
    @parent = parent
  end
end

describe SectionHeritage do
  let(:parent) { MyNode.new section: 'my_section' }
  let(:child) { MyNode.new parent: parent }

  before do
    child.validate
  end

  subject { child.section }

  it { is_expected.to eq parent.section }
end
