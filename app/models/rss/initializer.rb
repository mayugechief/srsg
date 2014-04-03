# coding: utf-8
module Rss
  class Initializer
    SS::FeedFilter.included do |mod|
      mod.include Rss::RssFilter
    end
  end
end
