require 'rails_helper'

RSpec.describe SectionsController, :type => :controller do
  describe 'GET #show' do

    describe 'finding a section' do

      let! (:root) { Fabricate(:section, slug: "root")}
      let! (:layout_section) { Fabricate(:section, slug: "layout_section", layout: 'communications')}
      let! (:zero) { Fabricate(:node, name: "zero", section: root) }


      context "given a non-existing section" do
        it "should throw a not found" do
          expect {
            get :show, params: {:section => "no-section"}
          }.to raise_error ActiveRecord::RecordNotFound
        end
      end

      context "given an existing section" do
        it "should return the page successfully" do
          get :show, params: {:section => "root"}
          expect(response.status).to eq(200)
        end
      end
      context "given an existing section with a layout" do
        it "should return the page successfully" do
          get :show, params: {:section => "layout_section"}
          expect(response.status).to eq(200)
        end
      end
    end
  end

  describe 'GET #index' do

    let! (:section_b) { Fabricate(:section, name: "b")}
    let! (:section_a) { Fabricate(:section, name: "a")}

    it "should assign @sections in name order" do
      get :index
      expect(assigns(:sections)).to eq([section_a, section_b])
    end
  end
end