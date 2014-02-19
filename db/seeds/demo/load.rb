# coding: utf-8

Dir.chdir @root = File.dirname(__FILE__)
@site = SS::Site.find_by host: ENV["site"]

## -------------------------------------
puts "groups:"

def save_group(data)
  puts "  #{data[:name]}"
  cond = { name: data[:name] }
  
  item = SS::Group.find_or_create_by cond
  item.update
end

save_group name: "A部/A01課"
save_group name: "A部/A02課"
save_group name: "B部/B01課"
save_group name: "B部/B02課"

## -------------------------------------
puts "files:"

Dir.glob "files/**/*.*" do |file|
  puts "  " + name = file.sub(/^files\//, "")
  Storage.binwrite "#{@site.path}/#{name}", File.binread(file)
end

## -------------------------------------
puts "layouts:"

def save_layout(data)
  puts "  #{data[:name]}"
  cond = { site_id: @site._id, filename: data[:filename] }
  html = File.read("layouts/" + data[:filename]) rescue nil
  
  item = Cms::Layout.find_or_create_by cond
  item.update data.merge html: html
end

save_layout filename: "top.layout.html", name: "トップレイアウト"
save_layout filename: "page.layout.html", name: "記事レイアウト"

array   = Cms::Layout.where(site_id: @site._id).map {|m| [m.filename.sub(/\..*/, ""), m] }
layouts = Hash[*array.flatten]

## -------------------------------------
puts "pieces:"

def save_piece(data)
  puts "  #{data[:name]}"
  cond = { site_id: @site._id, filename: data[:filename] }
  html = File.read("pieces/" + data[:filename]) rescue nil
  
  item = Cms::Piece.find_or_create_by cond
  item.update data.merge html: html
end

save_piece filename: "head.piece.html", name: "ヘッダー"
save_piece filename: "navi.piece.html", name: "ナビ"
save_piece filename: "menu.piece.html", name: "メニュー"
save_piece filename: "side.piece.html", name: "サイド"
save_piece filename: "foot.piece.html", name: "フッター"
save_piece filename: "docs/recent.piece.html", name: "新着情報", route: "article/pages"

## -------------------------------------
puts "nodes:"

def save_node(data)
  puts "  #{data[:name]}"
  cond = { site_id: @site._id, filename: data[:filename] }
  
  item = Cms::Node.find_or_create_by cond
  item.update data
end

save_node route: "uploader/files", filename: "css", name: "CSS"
save_node route: "uploader/files", filename: "img", name: "画像"
save_node route: "article/pages" , filename: "docs", name: "記事", shortcut: 1
save_node route: "category/nodes", filename: "kurashi", name: "暮らし", shortcut: 1
save_node route: "category/pages", filename: "kurashi/kosodate", name: "子育て"
save_node route: "category/nodes", filename: "kurashi/fukushi", name: "福祉"
save_node route: "category/pages", filename: "kurashi/fukushi/jido", name: "児童福祉"
save_node route: "category/pages", filename: "kurashi/fukushi/shogai", name: "障がい者福祉"
save_node route: "category/nodes", filename: "lifeevent", name: "ライフイベント", shortcut: 1
save_node route: "category/pages", filename: "lifeevent/kekkon", name: "結婚"
save_node route: "category/pages", filename: "lifeevent/shussan", name:"出産"

## layout
Cms::Node.where(site_id: @site._id, route: /^article\//).update_all(layout_id: layouts["page"].id)
Cms::Node.where(site_id: @site._id, route: /^category\//).update_all(layout_id: layouts["page"].id)

## -------------------------------------
puts "pages:"

def save_page(data)
  puts "  #{data[:name]}"
  cond = { site_id: @site._id, filename: data[:filename] }
  
  item = Cms::Page.find_or_create_by cond
  item.update data
end

save_page filename: "index.html", name: "トップページ", layout_id: layouts["top"].id

## -------------------------------------
puts "articles:"

1.step(9) do |i|
  save_page filename: "docs/#{i}.html", name: "サンプル記事#{i}", html: "<p>本文です。</p>",
    route: "article/pages", layout_id: layouts["page"].id,
    category_ids: Category::Node.pluck(:_id).sample(4)
end
