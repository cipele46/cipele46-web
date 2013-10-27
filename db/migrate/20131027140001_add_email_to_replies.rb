class AddEmailToReplies < ActiveRecord::Migration
  def change
    add_column :replies, :email, :string
  end
end
