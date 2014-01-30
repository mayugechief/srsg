# coding: utf-8
class Sns::MypageController < ApplicationController
  include SS::BaseFilter
  include Sns::BaseFilter
  
  skip_filter :logged_in?, only: [:login, :logout]
  
  private
    def set_params
      params.require(:item).permit(:email, :password, :ref)
    end
    
  public
    def index
      #mypage
    end
    
    def login
      @item = SS::User.new
      @item.email    = params[:email]
      @item.password = params[:password]
      return if !request.post?
        
      @item.attributes = set_params
      user = SS::User.where(email: @item.email, password: SS::Crypt.crypt(@item.password)).first
      return if !user
      
      if params[:ref].blank? || [sns_login_path, sns_mypage_path].index(params[:ref])
        return set_user user, session: true, redirect: true
      end
      
      set_user user, session: true
      render action: :redirect
    end
    
    def logout
      unset_user redirect: true
    end
end
