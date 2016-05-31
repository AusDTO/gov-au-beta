require 'rails_helper'

RSpec.describe Preview, type: :model do

  it { is_expected.to validate_presence_of(:token) }
  it { is_expected.to validate_uniqueness_of(:token) }
  it { is_expected.to validate_presence_of(:section) }
  it { is_expected.to validate_presence_of(:content_blocks) }
  it { is_expected.to validate_presence_of(:template) }

  describe 'semantic body' do
    let(:valid_body) {{
      section: { name: 'foo', layout: 'bar' },
      content_blocks: [
        { body: '<p>whatever</p>' }
      ],
      template: 'custom-template',
    }}

    subject { Fabricate.build(:preview, body: body)}

    context 'with a semantically valid body' do
      let(:body) { valid_body }
      it { is_expected.to be_valid }
    end

    context 'with a nameless section' do
      let(:body) { valid_body.merge(section: { layout: 'bar'})}
      it { is_expected.not_to be_valid }
    end

    context 'without an explicitly defined section layout' do
      let(:body) { valid_body.merge({ section: { name: 'foo'}})}
      it { is_expected.to be_valid } # This is fine (uses default layout)
    end

    context 'with body-less content blocks' do
      let(:body) { valid_body.merge({ content_blocks: [{}]})}
      it { is_expected.not_to be_valid }
    end

  end

end
