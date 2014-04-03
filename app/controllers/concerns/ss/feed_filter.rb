# coding: utf-8
module SS::FeedFilter
  extend ActiveSupport::Concern
  
  private
    def render_rss(channel, items)
      '<?xml version="1.0" encoding="UTF-8"?><rss />'
    end
    
    def render_atom(feed, items)
      '<?xml version="1.0" encoding="UTF-8"?><feed />'
    end
end
