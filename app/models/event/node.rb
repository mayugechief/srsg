# coding: utf-8
class Event::Node
  include Cms::Node::Model

  scope :my_route, -> { where route: /^event\// }

  class Page
    include Cms::Node::Model

    field :limit, type: Integer, default: 20
    permit_params :limit
    scope :my_route, -> { where route: "event/pages" }
  end
end
