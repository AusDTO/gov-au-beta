require 'rails_helper'

RSpec.describe AccessDeniedConcern, type: :controller do

  controller(ActionController::Base) do
    include AccessDeniedConcern

    before_action do
      authorize! :read, :index
    end

    def index
      render :nothing => true
    end
  end

  let(:user) { Fabricate(:user) }

  # See: https://github.com/CanCanCommunity/cancancan/wiki/Testing-Abilities#controller-testing
  let(:ability) do
    Object.new.tap{|obj| obj.extend(CanCan::Ability)}
  end

  context 'when user is not signed in' do
    context 'the controller' do
      before { get :index }
      subject { @controller }
      it { is_expected.to set_flash[:alert].to("You must sign in to access the requested page.") }
    end

    context 'the response' do
      subject { get :index }
      it { is_expected.to redirect_to(new_user_session_path) }
    end
  end

  context 'when user is signed in but not authorized' do
    before(:each) do
      ability.cannot :read, :index
      allow(@controller).to receive(:current_ability).and_return(ability) 
      sign_in(user)
    end

    after(:each) do
      sign_out(user)
    end

    context 'the controller' do
      before { get :index }
      subject { @controller }
      it { is_expected.to set_flash[:alert].to("You are not authorized to access this page.") }
    end

    context 'the response' do
      subject { get :index }
      it { is_expected.to have_http_status(:unauthorized) }
    end
  end
end


