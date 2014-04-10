# coding: utf-8
module Article::Part
  class Page
    include Cms::Part::Model
    include Cms::Addons::PageList
  end
end
