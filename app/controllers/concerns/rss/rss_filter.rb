# coding: utf-8
require "rss/maker"
module Rss::RssFilter
  extend ActiveSupport::Concern
  
  included do |mod|
    #alias_method :render_rss, :extend_render_rss
  end
  
  private
    def render_rss(node, items)
      rss = RSS::Maker.make("2.0") do |rss|
        summary = nil
        %w[description name].each do |m|
          summary = node.send(m) if summary.blank? && node.respond_to?(m)
        end
        
        rss.channel.title       = "#{node.name} - #{node.site.name}"
        rss.channel.link        = node.full_url
        rss.channel.description = summary
        rss.channel.about       = node.full_url
        rss.channel.language    = "ja"
        #rss.channel.pubDate     = date.to_s
        
        items.each do |item|
          date = nil
          %w[published updated created].each {|m| date ||= item.send(m) if item.respond_to?(m) }
          
          summary = nil
          #%w[summary description].each {|m| summary ||= item.send(m) if item.respond_to?(m) }
          
          rss.items.new_item do |entry|
            entry.title       = item.name
            entry.link        = item.full_url
            entry.description = summary if summary.present?
            entry.pubDate     = date.to_s if date.present?
          end
        end
      end
      
      rss.to_s
    end
end
