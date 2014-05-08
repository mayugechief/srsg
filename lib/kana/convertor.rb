# coding: utf-8
module Kana::Convertor
  @@mecab = nil
  
  if SS.config.kana.disable == false
    require "MeCab"
    @@mecab = MeCab::Tagger
    
    #require "natto"
    #@@mecab = Natto::MeCab
  end
  
  class << self
    public
      def kana_html(html)
        return html unless @@mecab
        
        text = html.gsub(/[\r\n\t]/, " ")
        tags = %w[head ruby script style]
        text.gsub!(/<!\[CDATA\[.*?\]\]>/m) {|m| mpad(m) }
        text.gsub!(/<!--.*?-->/m) {|m| mpad(m) }
        tags.each {|t| text.gsub!(/<#{t}( [^>]*\/>|[^\w].*?<\/#{t}>)/m) {|m| mpad(m) } }
        text.gsub!(/<.*?>/m) {|m| mpad(m) }
        text.gsub!(/[ -~]/m, "\r")
        
        byte = html.bytes
        kana = ""
        pl   = 0
        
        mecab = @@mecab.new('--node-format=%ps,%pe,%m,%H\n --unk-format=')
        # http://mecab.googlecode.com/svn/trunk/mecab/doc/format.html
        
        mecab.parse(text).split(/\n/).each do |line|
          next if line == "EOS"
          data = line.split(",")
          next if data[2] !~ /[一-龠]/
          
          ps = data[0].to_i
          pe = data[1].to_i
          kana << byte[pl..ps-1].pack("C*").force_encoding("utf-8") if ps != pl
          yomi = data[10].to_s.tr("ァ-ン", "ぁ-ん")
          kana << "<ruby>#{data[2]}<rp>(</rp><rt>#{yomi}</rt><rp>)</rp></ruby>"
          pl = pe
        end
        
        kana << byte[pl..-1].pack("C*").force_encoding("utf-8")
        kana.strip
      end
      
    private
      def mpad(str)
        str.gsub(/[^ -~]/, "   ")
      end
  end
end
