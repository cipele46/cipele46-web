class RenameTypeToAdType < ActiveRecord::Migration
  def up
    rename_column :ads, :type, :ad_type
  end

  def down
    rename_column :ads, :ad_type, :type
  end
end
