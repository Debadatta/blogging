class CreateCurrencies < ActiveRecord::Migration
  def change
    create_table :currencies do |t|
      t.string :currency_code, :null => false
      t.string :currency_symbol
      t.timestamps
    end
  end
end
