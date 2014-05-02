# coding: utf-8
module Acl::Addon::Owners
  class EditCell < Cell::Rails
    include SS::AddonFilter::EditCell
    
    javascript "acl/owners"
    javascript "jquery.multi-select.js"
 #   stylesheet "jquery-ui/multi-select/css/multi-select.css"
      
    def new
      if @cur_node.present?
        @item.owner_group_ids = @cur_node.owner_group_ids
      end
      render partial: "form"
    end
  end

  class ViewCell < Cell::Rails
    include SS::AddonFilter::ViewCell
  end
end