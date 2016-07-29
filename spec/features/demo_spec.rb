require 'rails_helper'
require 'database_dump_loader'

RSpec.describe 'demo', type: :feature do

  Warden.test_mode!

  before do
    # Load a snapshot of production data into the test database
    DatabaseDumpLoader.new(File.read(File.expand_path('demo-data.sql', File.dirname(__FILE__)))).load
  end

  it "should be possible to demo the application" do
    visit root_path
    expect(page.title).to eql("GovAuBeta")
    expect(page).to have_css('h2', :text => 'Information and services')
    expect(page).to have_css('h2', :text => 'About Australia')
  end
end

