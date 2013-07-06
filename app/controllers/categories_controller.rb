class CategoriesController < ApplicationController
  respond_to :json

  def index
    @categories = Category.order(:name)
    respond_with @categories
  end

end
