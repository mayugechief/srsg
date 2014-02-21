# coding: utf-8
module Cms::EditorFilter
  
  module Edit
    extend ActiveSupport::Concern
    
    included do
      helper ApplicationHelper
    end
    
    public
      def show(opts)
        render locals: opts
      end
      
      def update(opts)
        render partial: "form", locals: opts
      end
  end
  
  module View
    extend ActiveSupport::Concern
    
    public
      def index(opts)
        render locals: opts
      end
  end
end
