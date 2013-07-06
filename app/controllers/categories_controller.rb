class CategoriesController < ApplicationController
  def index
    @categories = Category.find(:all, :order => :name)
     
    respond_to do |format|
      format.json do 
        render :json => @categories
      end
    end
  end
end
