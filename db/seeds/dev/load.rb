# coding: utf-8

Dir.chdir @root = File.dirname(__FILE__)
@site = SS::Site.find_by host: ENV["site"]

## -------------------------------------
puts "files:"

Dir.glob "files/**/*.*" do |file|
  puts "  " + name = file.sub(/^files\//, "")
  Fs.binwrite "#{@site.path}/#{name}", File.binread(file)
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
puts "nodes:"

def save_node(data)
  puts "  #{data[:name]}"
  cond = { site_id: @site._id, filename: data[:filename] }
  
  item = Cms::Node.find_or_create_by cond
  item.update data
end

save_node route: "uploader/files", filename: "css", name: "CSS", shortcut: "show"
save_node route: "article/pages" , filename: "docs", name: "記事", shortcut: "show"
save_node route: "category/nodes", filename: "kurashi", name: "暮らし", shortcut: "show"
save_node route: "category/nodes", filename: "kurashi/fukushi", name: "福祉"
save_node route: "category/pages", filename: "kurashi/fukushi/jido", name: "児童福祉"
save_node route: "category/pages", filename: "kurashi/fukushi/shogai", name: "障がい者福祉"
save_node route: "category/pages", filename: "kurashi/kosodate", name: "子育て"
save_node route: "category/nodes", filename: "cate2", name: "カテゴリ2"
save_node route: "category/pages", filename: "cate2/cate1", name: "カテゴリ2-1"
save_node route: "category/pages", filename: "cate2/cate2", name:"カテゴリ2-2"

## layout
Cms::Node.where(site_id: @site._id, route: /^article\//).update_all(layout_id: layouts["page"].id)
Cms::Node.where(site_id: @site._id, route: /^category\//).update_all(layout_id: layouts["page"].id)

## -------------------------------------
puts "parts:"

def save_part(data)
  puts "  #{data[:name]}"
  cond = { site_id: @site._id, filename: data[:filename] }
  html = File.read("parts/" + data[:filename]) rescue nil
  
  item = Cms::Part.find_or_create_by cond
  item.update data.merge html: html
end

save_part route: "cms/frees", filename: "head.part.html", name: "ヘッダー"
save_part route: "cms/frees", filename: "navi.part.html", name: "ナビ"
save_part route: "cms/frees", filename: "foot.part.html", name: "フッター"
save_part route: "cms/crumbs", filename: "crumbs.part.html", name: "パンくず"
save_part route: "node/nodes", filename: "nodes.part.html", name: "フォルダ/フォルダ"
save_part route: "node/pages", filename: "pages.part.html", name: "フォルダ/ページ"
save_part route: "node/nodes", filename: "dir/nodes.part.html", name: "フォルダ/フォルダ"
save_part route: "node/pages", filename: "dir/pages.part.html", name: "フォルダ/ページ"
save_part route: "article/pages", filename: "docs/pages.part.html", name: "記事"
save_part route: "category/nodes", filename: "kurashi/nodes.part.html", name: "カテゴリー/フォルダ"
save_part route: "category/pages", filename: "kurashi/pages.part.html", name: "カテゴリー/ページ"

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
    category_ids: Category::Node.my_route.pluck(:_id).sample(4)
end
