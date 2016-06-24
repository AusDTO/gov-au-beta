require 'rails_helper'

RSpec.describe NodeDecorator, type: :decorator do
  describe '#content_body' do

    context 'renders markdown' do
      subject { Fabricate(:general_content, content_body: '# Heading').decorate.content_body }
      it { is_expected.to match('<h1>') }
    end
  end
end
