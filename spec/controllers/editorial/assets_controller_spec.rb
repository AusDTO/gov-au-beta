require 'rails_helper'

RSpec.describe Editorial::AssetsController, type: :controller do

  let(:owner) { Fabricate(:user, is_admin: true) }

  before do
    sign_in(owner)
  end

  describe '#index' do
    subject { get :index }

    it { is_expected.to be_success }
  end

  describe '#new' do
    subject { get :new }

    it { is_expected.to be_success }
  end

  describe '#create' do
    subject { post :create, params: {asset: params} }

    context 'with valid params' do
      let(:params) do
        Fabricate.attributes_for( :asset )
      end

      it { is_expected.to redirect_to(editorial_root_path) }

      it 'creates the asset' do
        expect { subject }.to change(Asset, :count).by(1)
      end
    end

    context 'without file' do
      let (:params) {{asset_file: nil}}

      it 'does not create the asset' do
        expect { subject }.not_to change(Asset, :count)
      end
    end
  end

end
