# coding: utf-8
module Rss::RssHelper
  def render_rss(node, items)
    xml = '<?xml version="1.0" encoding="UTF-8"?>
      <rss version="2.0" xmlns:blogChannel="http://backend.userland.com/blogChannelModule">
      
      <channel>
      <title>Yahoo!ニュース・トピックス - トップ</title>
      <link>http://dailynews.yahoo.co.jp/fc/</link>
      <description>Yahoo! JAPANのニュース・トピックスで取り上げている最新の見出しを提供しています。</description>
      <language>ja</language>
      <pubDate>Tue, 01 Apr 2014 16:17:44 +0900</pubDate>
      
      <item>
      <title>理研 論文取り下げ勧告検討</title>
      <link>http://dailynews.yahoo.co.jp/fc/science/stap_cells/</link>
      <pubDate>Tue, 01 Apr 2014 13:54:46 +0900</pubDate><enclosure length="133" url="http://i.yimg.jp/images/icon/photo.gif" type="image/gif" />
      <guid isPermaLink="false">yahoo/news/topics/6122725</guid>
      </item>
      
      </channel>
      </rss>';
  end
end
