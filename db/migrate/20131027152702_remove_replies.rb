class RemoveReplies < ActiveRecord::Migration
  def up
    drop_table :replies
  end
end
