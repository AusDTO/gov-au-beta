require 'rails_helper'
require 'database_dump_loader'

RSpec.describe 'demo', type: :feature do

  Warden.test_mode!

  before do
    # Load a snapshot of production data into the test database
    DatabaseDumpLoader.new(File.read(File.expand_path('demo-data.sql', File.dirname(__FILE__)))).load
  end

  it "should be possible to demo the application" do
    visit '/'

    expect(page.current_path).to eql("/")
    expect(page.title).to eql("GOV.AU")
    expect(page).to have_css('h2', :text => 'Information and services')
    expect(page).to have_css('h2', :text => 'About Australia')
    page.find('.next-holiday a').click

    expect(page.current_path).to eql("/times-and-dates/australian-public-holidays")
    expect(page).to have_css('h1', :text => 'Australian public holidays')
    page.find('a', :text => 'School holidays and term dates').click

    expect(page.current_path).to eql("/times-and-dates/school-holidays-and-term-dates")
    expect(page).to have_css('h1', :text => 'School holidays and term dates')
    page.find('nav.breadcrumbs--inverted a', :text => 'Home').click

    expect(page.current_path).to eql("/")
    expect(page).to have_css('section.government-links h2', :text => 'Australian Government')
    page.find('a', :text => /18 Departments/).click

    expect(page.current_path).to eql("/departments")
    page.find('article.content-listing li a', :text => 'Department of Communications and the Arts').click

    expect(page.current_path).to eql('/department-of-communications-and-the-arts')
    page.find('aside a', :text => 'Our role').click

    expect(page.current_path).to eql('/department-of-communications-and-the-arts/our-role')
    page.find('aside a', :text => 'Careers').click

    expect(page.current_path).to eql('/department-of-communications-and-the-arts/careers')
    page.find('aside a', :text => 'Our role').click

    expect(page.current_path).to eql('/department-of-communications-and-the-arts/our-role')
    page.find('.content-main a', :text => 'Television (TV) reception').click

    expect(page.current_path).to eql('/television-tv-reception')
    page.find('nav.breadcrumbs--inverted a', :text => 'Home').click
    page.find('a', :text => /18 Departments/).click
    page.find('article.content-listing li a', :text => 'Department of Communications and the Arts').click

    expect(page.current_path).to eql('/department-of-communications-and-the-arts')
    expect(page).to have_content 'Senator the Hon Mitch Fifield'
    page.find('a', :text => 'Minister for Communications').click

    expect(page.current_path).to eql('/minister-for-communications')
  end
end
