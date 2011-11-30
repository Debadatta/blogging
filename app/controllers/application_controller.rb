class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :set_cache_buster, :currency_list, :set_currency_session
  #before_filter :authenticate
  include SessionsHelper
  #include ACL9
  rescue_from 'Acl9::AccessDenied', :with => :access_denied
  
  
  def set_cache_buster
    response.headers["Cache-Control"] = "no-cache, no-store, max-age=0, must-revalidate"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
  end

  def authenticate
    deny_access unless signed_in?
  end
  
  def currency_list
    @currencies = Currency.all
  end
  
  def set_currency_session
    if not session['currency']
      @currency = Currency.find_by_currency_code("USA")
      session['currency']=@currency.currency_code
      session['currency_id'] = @currency.id
      session['currency_symbol'] = @currency.currency_symbol
    end
  end
 
end
