require 'rails_helper'

RSpec.describe PreviewsController, type: :controller do
  describe 'GET #show' do

    let(:preview) { Fabricate(:populated_preview) }

    before do
      get :show, params: { token: preview.token }
    end

    describe 'viewing content' do

      it { is_expected.to respond_with 200 }

      it { is_expected.to render_template "templates/#{preview.template}" }

      it { is_expected.to render_with_layout preview.section['layout'] }

      it { expect(assigns(:node)).to eq preview }

    end
  end
end
