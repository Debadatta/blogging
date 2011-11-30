class CreateTableCurrenciesProducts < ActiveRecord::Migration
  def up
    create_table :currencies_products, :id => false do |t|
        t.references :currency
        t.references :product
        t.timestamps
      end
  end

  def down
    drop_table :currencies_products
  end
end
