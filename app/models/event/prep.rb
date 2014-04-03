# coding: utf-8
module Event
  class Prep
    Cms::Node.plugin "event/pages"
    Cms::Page.addon "event/dates"
  end
end
