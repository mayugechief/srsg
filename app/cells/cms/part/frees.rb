# coding: utf-8
class Cms::Part::Frees
  
  class EditCell < Cell::Rails
    include Cms::PartFilter::EditCell
    
    model Cms::Part
  end
end