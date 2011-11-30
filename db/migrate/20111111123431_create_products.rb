class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string :name, :null => false
      t.references :category
      t.string :image
      t.decimal :price, :precision => 10, :scale => 2, :default => 0
      t.text :description
      
      t.timestamps
    end
  end
end
