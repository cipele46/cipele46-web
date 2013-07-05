class CreateFavorites < ActiveRecord::Migration
  def change
    create_table :favorites do |t|
      t.references :ad
      t.references :user

      t.timestamps
    end
    add_index :favorites, :ad_id
    add_index :favorites, :user_id
  end
end
