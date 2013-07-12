class AddSlugToBlogs < ActiveRecord::Migration
  def change
    add_column :blogs, :slug, :string
  end
end
