require 'rails_helper'

RSpec.describe ApplicationHelper do
  context 'with a separate editorial url' do
    it 'provides the correct editorial url for' do
      expect(editorial_url_for('/bar')).to eq("#{Rails.configuration.editorial_base_url}/bar")
    end
  end
end