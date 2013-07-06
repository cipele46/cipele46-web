class BlogController < ApplicationController
  
  def index
    @posts = Blog.order("id desc")
  end

  def show
    @post = Blog.find(params[:id].to_i)
  end

end
