# coding: utf-8
module Event::Addon::Dates
  class EditCell < Cell::Rails
    include SS::AddonFilter::EditCell
    
    javascript "event/event"
  end

  class ViewCell < Cell::Rails
    include SS::AddonFilter::ViewCell
  end
end
