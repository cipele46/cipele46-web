class RemoveFacebookUidFromUser < ActiveRecord::Migration
  def up
    remove_column :users, :facebook_uid
  end

  def down
    add_column :users, :facebook_uid, :string
  end
end
