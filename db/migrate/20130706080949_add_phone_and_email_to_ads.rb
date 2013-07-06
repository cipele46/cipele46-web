class AddPhoneAndEmailToAds < ActiveRecord::Migration
  def change
    add_column :ads, :phone, :string
    add_column :ads, :email, :string
  end
end
