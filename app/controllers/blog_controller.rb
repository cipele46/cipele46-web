class BlogController < ApplicationController

  def index
    @all_posts = Blog.select("slug, title").order("id desc")
    @main_posts = Blog.order("id desc").limit(5)
  end

  def show
    @post = Blog.find(params[:id])
    @site_title = @post.title
  end

end
