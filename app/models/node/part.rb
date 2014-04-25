# coding: utf-8
class Node::Part
  include Cms::Part::Model
  
  class Node
    include Cms::Part::Model
    include Cms::Addons::NodeList
  end
  
  class Page
    include Cms::Part::Model
    include Cms::Addons::PageList
  end
end
