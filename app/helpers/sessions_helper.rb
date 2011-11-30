module SessionsHelper
  
  def sign_in_by_cookie(user)
    #cookies.permanent.signed[:remember_token] = {:expire => 2.minutes.from_now()}
    cookies.permanent.signed[:remember_token] = [user.id, user.salt]
    current_user = user
  end
  
  def sign_in(user)
    session[:user_id] = user.id
    self.current_user = user
  end
  
  def current_user=(user)
    @current_user = user
  end
  
  
  def current_user   
      if session[:user_id]
        @current_user ||= User.find(session[:user_id])
      else
        @current_user ||= user_from_remember_token
      end
  end
  
  # def current_user
  # @current_user ||= User.find(session[:user_id]) if session[:user_id]
  # #@current_user ||= user_from_remember_token
  # end
  
  def signed_in?
    !current_user.nil?
  end
  
  # def sign_out
    # cookies.delete(:remember_token)
    # current_user = nil
  # end
  
  def sign_out
  #cookies.delete(:remember_token)
  if !cookies[:remember_token].nil?
    cookies.delete(:remember_token)
  end
  session[:current_cart] = []
  session[:current_cart] = nil
  session[:current_cart_price] = nil
  session[:user_id] = nil
  self.current_user = nil
  reset_session
  end
  
  def current_user?(user)
    user == current_user
  end
  
  def deny_access
    store_location
    redirect_to signin_path, :notice => "Please sign in to access this page."
  end
  
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    clear_return_to
  end
  
  def current_currency
    @currenct_currency ||= assign_currency_session
  end
  
private

  def user_from_remember_token
    User.authenticate_with_salt(*remember_token)
  end
  
  def remember_token
    cookies.signed[:remember_token] || [nil, nil]
  end
  
  def store_location
    session[:return_to] = request.fullpath
  end
  
  def clear_return_to
    session[:return_to] = nil
  end
  
  def assign_currency_session
    
  end
end
