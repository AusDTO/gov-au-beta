class CategoriesController < ApplicationController
  def show
    @category = Category.friendly.find(params[:slug])
  end
end
