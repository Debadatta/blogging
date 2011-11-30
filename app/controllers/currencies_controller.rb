class CurrenciesController < ApplicationController
  before_filter :authenticate
  layout 'app_setting'
  
  def index
    @currencies = Currency.all
  end

  def new
    @currency = Currency.new
  end

  def create
    @currency = Currency.new(params[:currency])
    if @currency.save
      redirect_to currencies_path
    else
      render 'new'
    end
  end

  def edit
    @currency = Currency.find(params[:id])
    render 'new'
  end

  def update
    @currency = Currency.find(params[:id])
    if @currency.update_attributes(params[:currency])
      redirect_to currencies_path
    else
      render 'edit'
    end
  end

  def destroy
    @currency = Currency.find(params[:id])
    @currency.destroy()
    redirect_to currencies_path
  end
  
end
