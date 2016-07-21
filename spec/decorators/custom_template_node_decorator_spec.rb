require 'rails_helper'

RSpec.describe CustomTemplateNodeDecorator, type: :decorator do
  describe '#template' do
    let(:template) { 'custom/public_hols_tas'}
    let(:node) { Fabricate(:custom_template_node, template: template) }
    subject { described_class.new(node).template }

    it { is_expected.to eq(template) }
  end
end
