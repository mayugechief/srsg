# coding: utf-8
module Article::Part
  
  class Page
    include Cms::Part::Model
    
    field :limit, type: Integer, default: 20
  end
end
