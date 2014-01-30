# coding: utf-8
module Cms::EditorFilter
  
  module Edit
    extend ActiveSupport::Concern
    
    included do
      helper ApplicationHelper
    end
    
    def show(opts)
      render locals: opts
    end
    
    def update(opts)
      render partial: "form", locals: opts
    end
  end
  
  module View
    extend ActiveSupport::Concern
    
    def index(opts)
      render locals: opts
    end
  end
end
