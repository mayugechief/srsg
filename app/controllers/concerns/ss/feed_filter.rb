# coding: utf-8
module SS::FeedFilter
  extend ActiveSupport::Concern
  
  private
    def render_rss(channel, items)
      return super if defined?(super)
      '<?xml version="1.0" encoding="UTF-8"?><rss />'
    end
    
    def render_atom(feed, items)
      return super if defined?(super)
      '<?xml version="1.0" encoding="UTF-8"?><feed />'
    end
end
