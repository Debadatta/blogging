class CreatePrices < ActiveRecord::Migration
  def change
    create_table :prices do |t|
      t.decimal :price, :precision => 10, :scale => 2, :default => 0
      t.references :product
      t.references :currency

      t.timestamps
    end
  end
end
