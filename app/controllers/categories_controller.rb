class CategoriesController < ApplicationController
  def show
    @category = Category.friendly.find(params[:slug])
    with_caching(@category)
  end
end
