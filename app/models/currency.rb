class Currency < ActiveRecord::Base
  
  attr_accessible :currency_code, :currency_symbol
  has_many :prices
  has_and_belongs_to_many :products
  #named_scope :has_prices,:joins =>{:product, :price}
end
