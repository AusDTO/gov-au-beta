require 'rails_helper'

RSpec.describe Admin::TopicsController, type: :controller do

  describe '#find_resource' do

    let(:department) { Fabricate(:department) }

    subject { Admin::DepartmentsController.new.find_resource(department.id) }

    it { is_expected.to eq(department) }

  end

end
