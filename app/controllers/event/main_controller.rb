# coding: utf-8
class Event::MainController < ApplicationController
  include Cms::BaseFilter

  public
    def index
      redirect_to event_pages_path
    end
end
