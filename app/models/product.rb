class Product < ActiveRecord::Base
  belongs_to :category
  has_many :prices
  has_and_belongs_to_many :currencies
  attr_accessible :name, :category_id, :image, :price, :description
  
  validates :name, :presence => true,:length => { :maximum => 50 }
  validates :price, :format => { :with => /^\d+??(?:\.\d{0,2})?$/ }, :numericality => {:greater_than => 0}
  validates :category_id, :presence => true
  
  has_attached_file :avatar, :styles  => { :small => "100x100#", :large => "500x500>" }, :processors => [:cropper]
  attr_accessor :crop_x, :crop_y, :crop_w, :crop_h
  attr_accessible :name, :title
  attr_accessible :avatar, :avatar_file_name, :avatar_content_type, :avatar_file_size
  after_update :reprocess_avatar, :if => :cropping?
  
  def cropping?  
    !crop_x.blank? && !crop_y.blank? && !crop_w.blank? && !crop_h.blank?  
  end 
  
  def avatar_geometry(style = :original)  
    @geometry ||= {}  
    @geometry[style] ||= Paperclip::Geometry.from_file(avatar.path(style))  
  end  
  
  def paypal_url(return_url)
    values = {
      :business => 'sold_1318918836_biz@gmail.com',
      :cmd => '_cart',
      :upload => 1,
      :return => return_url,
      :invoice => id
    }
      values.merge!({
        "amount" => '$50.00',
        "item_name" => 'Blackberry',
        "item_number" => 1,
        "quantity" => 4
      })
    # session[:current_cart].each_pair {|key, value|
      # values.merge!({
#         
      # })
      # }
    "https://www.sandbox.paypal.com/cgi-bin/webscr?" + values.to_query
  end


  private  
  def reprocess_avatar  
    avatar.reprocess!  
  end 
end
