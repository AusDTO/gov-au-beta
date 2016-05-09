require 'rails_helper'

RSpec.describe NodesController, :type => :controller do

  let (:root) { Fabricate(:section, name: "root")}
  let (:zero) { Fabricate(:node, name: "zero", template: "default", order_num: 10, section: root) }
  #let!(:root) { Fabricate(:node, name: "root", template: "default") }

  %w(one two).each_with_index do |num, idx|
    let!(num.to_sym) { Fabricate(:node, name: "#{num}", section: root, order_num: idx, template: "default") }
  end

  %w(three four).each_with_index do |num, idx|
    let!(num.to_sym) { Fabricate(:node, name: "#{num}", section: root, order_num: idx, template: "default", parent: zero)}
  end

  %w(five six).each_with_index do |num, idx|
    let!(num.to_sym) { Fabricate(:node, name: "#{num}", section: root, order_num: idx, template: "default", parent: four)}
  end


  describe "GET #show" do

    context "given a non-existing section" do
      it "should return a 404" do
        get :show, {:section => "no-section"}
        expect(response.status).to eq(404)
      end

      context "given some path beneath a non-existing section" do
        it "should return a 404" do
          get :show, {:section => "no-section", path: "some-path"}
          expect(response.status).to eq(404)
        end
      end
    end

    context "given an existing node with a valid section" do
      it "should return the page successfully" do
        get :show, {:section => "root", path: "one"}
        expect(response.status).to eq(200)
      end
    end

    context "given a non-existing node beneath a valid section" do
      it "should return a 404" do
        get :show, {:section => "root", path: "not-existing"}
        expect(response.status).to eq(404)
      end
    end

    context "given a page with a valid parent" do
      it "should return the page successfully" do
        get :show, {:section => "root", path: "zero/three"}
        expect(response.status).to eq(200)
      end
    end

    context "given a page nested beneath another page" do
      it "should return the page successfully" do
        get :show, {:section => "root", path: "zero/four/six"}
        expect(response.status).to eq(200)
      end
    end

    context "given a non-existing page in a valid route" do
      it "should return a 404" do
        get :show, {:section => "root", path: "zero/four/six/eight"}
        expect(response.status).to eq(404)
      end
    end

    context "given an existing page beneath a non-existing section" do
      it "should return a 404" do
        get :show, {:section => "bad-section", path: "zero"}
        expect(response.status).to eq(404)
      end
    end
  end
end