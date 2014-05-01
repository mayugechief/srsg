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

save_layout filename: "home.layout.html", name: "トップレイアウト"
save_layout filename: "page.layout.html", name: "記事レイアウト"
save_layout filename: "prod.layout.html", name: "製品レイアウト"
save_layout filename: "work.layout.html", name: "業務レイアウト"
save_layout filename: "plan.layout.html", name: "計画レイアウト"

array   = Cms::Layout.where(site_id: @site._id).map {|m| [m.filename.sub(/\..*/, ""), m] }
layouts = Hash[*array.flatten]

## -------------------------------------
puts "nodes:"

def save_node(data)
  puts "  #{data[:name]}"
  klass = data[:route].sub("/", "/node/").singularize.camelize.constantize
  
  cond = { site_id: @site._id, filename: data[:filename] }
  item = klass.unscoped.find_or_create_by cond
  item.update data
end

save_node route: "uploader/file", filename: "css", name: "CSS", shortcut: "show"

save_node route: "article/page", filename: "docs", name: "記事", shortcut: "show"

save_node route: "category/page", filename: "topics", name: "注目記事", shortcut: "show", conditions: %w[prod]

save_node route: "cms/node", filename: "prod", name: "製品情報", shortcut: "show"
save_node route: "cms/page", filename: "prod/cms", name: "CMS"
save_node route: "cms/page", filename: "prod/sns", name: "SNS"
save_node route: "cms/page", filename: "prod/mail", name: "Mail"

save_node route: "category/node", filename: "work", name: "業務内容", shortcut: "show"
save_node route: "category/page", filename: "work/sales", name: "営業部"
save_node route: "category/page", filename: "work/devel", name: "開発部"
save_node route: "category/page", filename: "work/human", name: "人事部"

save_node route: "event/page", filename: "plan", name:"事業計画", shortcut: "show"

## layout
Cms::Node.where(site_id: @site._id, filename: /^topics/).update_all(layout_id: layouts["page"].id)
Cms::Node.where(site_id: @site._id, filename: /^docs/).update_all(layout_id: layouts["page"].id)
Cms::Node.where(site_id: @site._id, filename: /^pick/).update_all(layout_id: layouts["page"].id)
Cms::Node.where(site_id: @site._id, filename: /^prod/).update_all(layout_id: layouts["prod"].id)
Cms::Node.where(site_id: @site._id, filename: /^work/).update_all(layout_id: layouts["work"].id)
Cms::Node.where(site_id: @site._id, filename: /^plan/).update_all(layout_id: layouts["plan"].id)

## -------------------------------------
puts "parts:"

def save_part(data)
  puts "  #{data[:name]}"
  klass = data[:route].sub("/", "/part/").singularize.camelize.constantize
  
  cond = { site_id: @site._id, filename: data[:filename] }
  item = klass.unscoped.find_or_create_by cond
  html = File.read("parts/" + data[:filename]) rescue nil
  item.html = html if html
  item.update data
end

save_part route: "cms/free", filename: "head.part.html", name: "ヘッダー"
save_part route: "cms/free", filename: "navi.part.html", name: "ナビ"
save_part route: "cms/free", filename: "foot.part.html", name: "フッター"
save_part route: "cms/crumb", filename: "crumbs.part.html", name: "パンくず"

save_part route: "article/page", filename: "docs/pages.part.html", name: "新着記事リスト"
save_part route: "cms/page", filename: "topics/pages.part.html", name: "注目記事リスト", conditions: %w[prod]

save_part route: "cms/node", filename: "prod/nodes.part.html", name: "製品情報/フォルダ"
save_part route: "cms/page", filename: "prod/pages.part.html", name: "製品情報/ページ"

save_part route: "category/node", filename: "work/nodes.part.html", name: "業務内容/フォルダ"
save_part route: "cms/page", filename: "work/pages.part.html", name: "業務内容/ページ"

## -------------------------------------
puts "pages:"

def save_page(data)
  puts "  #{data[:name]}"
  cond = { site_id: @site._id, filename: data[:filename] }
  
  item = Cms::Page.find_or_create_by cond
  item.update data
end

body = "<p>#{'本文です。<br />' * 3}</p>" * 2

save_page filename: "index.html", name: "トップページ", layout_id: layouts["home"].id
save_page filename: "prod/index2.html", name: "仕様について", layout_id: layouts["prod"].id, html: body
save_page filename: "prod/index3.html", name: "サポートについて", layout_id: layouts["prod"].id, html: body
save_page filename: "prod/cms/price.html", name: "CMSの価格", layout_id: layouts["prod"].id, html: body
save_page filename: "prod/cms/license.html", name: "CMSのライセンス", layout_id: layouts["prod"].id, html: body
save_page filename: "prod/sns/price.html", name: "SNSの価格", layout_id: layouts["prod"].id, html: body
save_page filename: "prod/sns/license.html", name: "SNSのライセンス", layout_id: layouts["prod"].id, html: body
save_page filename: "prod/mail/price.html", name: "Mailの価格", layout_id: layouts["prod"].id, html: body
save_page filename: "prod/mail/license.html", name: "Mailのライセンス", layout_id: layouts["prod"].id, html: body

## -------------------------------------
puts "articles:"

1.step(9) do |i|
  save_page filename: "docs/#{i}.html", name: "サンプル記事#{i}", html: body,
    route: "article/page", layout_id: layouts["page"].id,
    category_ids: Category::Node::Base.pluck(:_id).sample(2)
end
