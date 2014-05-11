# coding: utf-8
class Cms::PublicController < ApplicationController
  include Cms::PublicFilter
  
  after_action :render_public, if: ->{ response.body.present? }
  after_action :put_access_log
  
  private
    def render_public
      response.body = embed_layout(response.body) unless SS.config.cms.ajax_layout
    end
    
    def put_access_log
      #
    end
end
