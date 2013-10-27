class RemoveUserIdFromReplies < ActiveRecord::Migration
  def up
    remove_column :replies, :user_id
  end

  def down
    add_column :replies, :user_id, :integer
  end
end
