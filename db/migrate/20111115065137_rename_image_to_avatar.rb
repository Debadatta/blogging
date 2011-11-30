class RenameImageToAvatar < ActiveRecord::Migration
  def up
    rename_column :products, :image, :avatar
  end

  def down
    rename_column :products, :avatar, :image
  end
end
