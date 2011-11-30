class ProductsController < ApplicationController
  before_filter :authenticate
  skip_filter :verify_authenticity_token, :add_to_cart,:remove_from_cart
  before_filter :default,:index, :counter,  :only => [:checkout_total, :check_out]
  layout 'shopping_cart'
  
  def index
    
    default
        
    if params[:format].nil?
      @products = Product.paginate(:page => params[:page],:include=>[:prices], :order => 'id asc',:per_page => 9)
    else
      @products = Product.paginate(:page => params[:page], :conditions=>{:category_id => params[:format]},:include=>[:prices], :per_page =>9)
    end    
    
    if !session[:current_cart].blank?
      @product_names = []
      @prices = []
      @quantity = []
      session[:current_cart].each  do |k,v|
        @price = Price.where(:product_id => k, :currency_id => session[:currency_id]).first.price.to_s
        @product_name = Product.where(:id => k).first.name
        @prices << @price
        @product_names << @product_name
        @quantity << v
      end
      
    end
    
  end
  
  def new
    @product = Product.new
    @categories = Category.all(:order => 'name asc')
    @currencies = Currency.all
    render :layout => 'app_setting'
  end

  def create
    @categories = Category.all(:order => 'name asc')
    @product = Product.new(params[:product])  
    @currencies = Currency.all
    
    @product.price = 5
    if @product.save  
      flash[:notice] = "Successfully created product."  
      if params[:product][:avatar].blank?  
        redirect_to '/product_list'
      else  
        render :action => 'crop'  
      end  
      
      #------------------------------------
      #Saving price 
      #------------------------------------
      
      for c in @currencies do
                
        if !params[:price]['price'+c.id.to_s].nil?
          @price = Price.new
          @price.price = params[:price]['price'+c.id.to_s]
          @price.product_id = Product.last.id
          @price.currency_id = c.id
          
          @price.save
        end
      end
    else  
      render :action => 'new', :layout => 'app_setting'
    end  
  end

  def list    
    @products = Product.paginate(:page => params[:page], :order => 'id asc',:per_page => 6)
    render :layout => 'app_setting'
  end

  def edit
    @product = Product.new(params[:id]) 
    render :layout => 'app_setting'
  end

  def update
    @product = Product.find(params[:id])  
    if @product.upadte_attributes(params[:product])  
      flash[:notice] = "Successfully created product."  
      if params[:product][:avatar].blank?  
        redirect_to @product  
      else  
        render :action => 'crop'  
      end  
    else  
      render :action => 'new'  
    end  
  end

  def destroy
  end
  
  def crop
    @product = Product.find(params[:id])
    @title = "New Image"
  end
  
  def add_to_cart
    @categories = Category.all(:order => 'name asc')
    @currencies = Currency.all
    @cart_product_id= params[:product_id] unless params[:product_id].nil?
    if !@cart_product_id.nil?
      if session[:current_cart].nil?
        session[:current_cart]=Hash.new
      end
      session[:current_cart][params[:product_id]] = session[:current_cart].include?(params[:product_id]) ? session[:current_cart][params[:product_id]]+1 : 1
      
    end
    if !session[:current_cart].nil?
      @product_names = []
      @prices = []
      @quantity = []
      session[:current_cart].each  do |k,v|
        @price = Price.where(:product_id => k, :currency_id => session[:currency_id]).first.price.to_s
        @product_name = Product.where(:id => k).first.name
        @prices << @price
        @product_names << @product_name
        @quantity << v
      end      
    end
    render :layout => false    
  end
  
  def remove_from_cart
    #adjust
    @cart_product_id= params[:product_id] unless params[:product_id].nil?
    if !@cart_product_id.nil?
      
      if session[:current_cart].nil?
        session[:current_cart]=Hash.new
      end
      
      if session[:current_cart][params[:product_id]].to_i==1
        session[:current_cart].delete(params[:product_id])
      else
        session[:current_cart][params[:product_id]] = session[:current_cart].include?(params[:product_id]) ? session[:current_cart][params[:product_id]]-1 : 1
      end
      default
    end
    render :action => 'add_to_cart', :layout => false    
  end
  
  def change_currency
    if !params[:currency].nil?
      @currency = Currency.find_by_currency_code(params[:currency])
      session[:currency] = params[:currency]
      session[:currency_id]= @currency.id  
      session[:currency_symbol] = @currency.currency_symbol
      redirect_to request.referer
    end
  end
  
  def check_out
    if !params[:product_id].nil?
      session[:current_cart].each_pair{|key,value|
      if params[:product_id].to_i == key.to_i
        session[:current_cart][params[:product_id]] = params[:value].to_i
      end
      }
    end
    index
     render :layout => false
  end
  
  def checkout_total
  end
  private
  
  def default
    #@categories = Category.all(:order => 'name asc')
    @categories = Category.all(:order => 'name asc')
    @currencies = Currency.all
    if !session[:current_cart].nil?
      @product_names = []
      @prices = []
      @quantity = []
      session[:current_cart].each  do |k,v|
        @price = Price.where(:product_id => k, :currency_id => session[:currency_id]).first.price.to_s
        @product_name = Product.where(:id => k).first.name
        @prices << @price
        @product_names << @product_name
        @quantity << v
      end      
    end
  end
  
  def counter
    @counter = Hash.new
     @counter[1] = 1
     @counter[2] = 2
     @counter[3] = 3
     @counter[4] = 4
     @counter[5] = 5
     @counter[6] = 6
     @counter[7] = 7
     @counter[8] = 8
     @counter[9] = 9
     @counter[10] = 10
  end
end
