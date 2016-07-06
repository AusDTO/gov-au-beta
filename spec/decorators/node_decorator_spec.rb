require 'rails_helper'

RSpec.describe NodeDecorator, type: :decorator do
  describe '#content_body' do

    def decorated_body(body)
      Fabricate(:general_content, content_body: body).decorate.content_body
    end

    context 'renders markdown' do
      subject { decorated_body('# Heading') }
      it { is_expected.to match('<h1>') }
    end

    context 'renders consecutive headings' do
      subject { decorated_body("# Heading\n## Heading 2") }
      it { is_expected.to match('<h2>') }
    end

    context 'tables' do
      subject { decorated_body("| h1 | h2 |\n|---|---|\n| c1 | c2 |") }
      it { is_expected.to have_css('table') }
      it { is_expected.to have_css('table.content-table') }
    end

    context 'handles no content' do
      subject { decorated_body(nil) }
      it { is_expected.to be_blank }
    end
  end
end
