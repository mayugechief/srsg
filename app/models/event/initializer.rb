# coding: utf-8
module Event
  class Initializer
    Cms::Node.plugin "event/page"
    Cms::Page.addon "event/date"
    
    Event::Page.inherit_addons Cms::Page
  end
end
