# coding: utf-8
class Cms::PublicController < ApplicationController
  include Cms::PublicFilter
  
  after_action :put_access_log
  
  def put_access_log
    #
  end
end
