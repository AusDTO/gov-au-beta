class CategoriesController < ApplicationController
  def show
    @category = Category.friendly.find(params[:slug])
    bustable_fresh_when(@category)
  end
end
