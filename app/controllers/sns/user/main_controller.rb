# coding: utf-8
class Sns::User::MainController < ApplicationController
  include Sns::BaseFilter
  
  public
    def index
      redirect_to sns_user_profile_path
    end
end
