# coding: utf-8
module Mobile
  class Initializer
    Cms::PublicController.include Mobile::MobileFilter
  end
end
