require 'rails_helper'

describe PreviewDecorator do
  let(:preview) { Fabricate.build(:populated_preview).decorate }

  describe 'section' do
    subject { preview.section }

    it { is_expected.to be_a Section }
  end

  describe 'content blocks' do
    subject { preview.content_blocks.first }

    it { is_expected.to be_a ContentBlock }
  end

end
