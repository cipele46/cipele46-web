class CreateReplies < ActiveRecord::Migration
  def change
    create_table :replies do |t|
      t.text :content
      t.references :user
      t.references :ad

      t.timestamps
    end
  end
end
