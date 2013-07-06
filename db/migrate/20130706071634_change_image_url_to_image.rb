class ChangeImageUrlToImage < ActiveRecord::Migration
  def change
    rename_column :ads, :image_url, :image
  end
end
