# coding: utf-8
module Cms::Addons::NodeList
  class EditCell < Cell::Rails
    include SS::AddonFilter::EditCell
  end
  
  class ViewCell < Cell::Rails
    include SS::AddonFilter::ViewCell
  end
end
