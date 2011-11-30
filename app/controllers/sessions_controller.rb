class SessionsController < ApplicationController
  #skip_filter :verify_authenticity_token, :only => :add_to_cart
  def new
    
  end
  
  def create    
    user = User.authenticate(params[:session][:email], params[:session][:password])
    if user.nil?
        # Create an error message and re-render the signin form.
        flash.now[:error] = "Invalid email/password combination."
        @title = "Sign in"
        render 'new'      
    else      
      if params[:session][:remember_me] == 0.to_s
        # Sign the user in and redirect to the user's show page.
        sign_in user
        redirect_back_or user
      else
        sign_in_by_cookie user
        redirect_back_or user
      end
    end
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end
  
  def add_to_cart
    @cart_product_id= params[:product_id] unless params[:product_id].nil?
    #respond_with(params[:product_id])
    #respond_with('params[:product_id]')
    if !@cart_product_id.nil?
      if session[:current_cart].nil?
        session[:current_cart]=Hash.new
      end
      session[:current_cart][params[:product_id]] = session[:current_cart].include?(params[:product_id]) ? session[:current_cart][params[:product_id]]+1 : 1
      # unless session[:current_cart].include?(@cart_product_id)
         # session[:current_cart] << @cart_product_id
      # end
    end
    
    respond_to do |format|
      format.json do
        render :json => {:current_cart => session[:current_cart], :quantity => session[:current_cart][params[:product_id]], :product_id => params[:product_id]}
      end        
    end

  end
  
  def empty_cart
    if !session[:current_cart].empty?
      session[:current_cart] = []
      session[:current_cart] = nil
      
      respond_to do |format|
        format.json do
          render :json => 1
        end        
      end
    end      
  end
  
end
