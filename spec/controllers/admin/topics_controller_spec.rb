require 'rails_helper'

RSpec.describe Admin::TopicsController, type: :controller do

  describe '#find_resource' do

    let(:topic) { Fabricate :topic }

    subject { Admin::TopicsController.new.find_resource topic.id }

    it { is_expected.to eq topic }

  end

end
