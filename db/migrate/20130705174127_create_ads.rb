class CreateAds < ActiveRecord::Migration
  def change
    create_table :ads do |t|
      t.string :title
      t.string :image_url
      t.text :description
      t.integer :type
      t.integer :status
      t.references :category
      t.references :user
      t.references :city
      
      t.timestamps
    end
    add_index :ads, :category_id
    add_index :ads, :user_id
    add_index :ads, :city_id
  end
end
