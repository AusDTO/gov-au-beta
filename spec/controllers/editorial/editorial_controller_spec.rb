require 'rails_helper'

RSpec.describe Editorial::EditorialController, type: :controller do

  describe 'GET #index' do
    let(:user) { Fabricate(:user) }
    let(:authenticated_request) { get :index }

    context 'when user is logged in' do
      before(:each) do
        sign_in(user)
        authenticated_request
      end

      after(:each) do
        sign_out(user)
      end

      describe "they can see the sections they collaborate on" do
        let! (:section_b) { Fabricate(:section, name: "b") }
        let! (:section_a) { Fabricate(:section, name: "a") }
        let! (:section_c) { Fabricate(:section, name: "c") }
        let! (:section_d) { Fabricate(:section, name: "d") }

        let! (:role_on_section_b) { Role.create!(:name => :author, :resource => section_b) }
        let! (:role_on_section_a) { Role.create!(:name => :reviewer, :resource => section_a) }
        let! (:role_on_section_d) { Role.create!(:name => :owner, :resource => section_d) }

        let(:user) do
          user = Fabricate(:user)
          user.roles << role_on_section_b
          user.roles << role_on_section_a
          user.roles << role_on_section_d
          user.save!
          user
        end

        it { is_expected.not_to set_flash[:alert] }

        it "should assign @sections" do
          expect(assigns(:sections)).to eq([section_a, section_b, section_d])
        end
      end
    end
  end
end
