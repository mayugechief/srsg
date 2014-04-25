# coding: utf-8
class ActionDispatch::Routing::Mapper
  def content(ns, &block)
    name = ns.gsub("/", "_")
    namespace(name, path: ".:host/#{ns}:cid", module: ns, cid: /\w+/) { yield }
  end
  
  def node(ns, &block)
    name = ns.gsub("/", "_")
    path = ".:host/node/#{ns}"
    namespace(name, as: "node_#{name}", path: path, module: "cms") { yield }
  end
  
  def page(ns, &block)
    name = ns.gsub("/", "_")
    path = ".:host/page/#{ns}"
    namespace(name, as: "page_#{name}", path: path, module: "cms") { yield }
  end
  
  def part(ns, &block)
    name = ns.gsub("/", "_")
    path = ".:host/part/#{ns}"
    namespace(name, as: "part_#{name}", path: path, module: "cms") { yield }
  end
end

SS::Application.routes.draw do
  
  SS::Initializer
  
  namespace "fs" do
    get ":id/:filename" => "files#index"
    get ":id/thumb/:filename" => "files#thumb"
  end
  
  namespace "sns", path: ".mypage" do
    get   "/"      => "mypage#index", as: :mypage
    get   "logout" => "login#logout", as: :logout
    match "login"  => "login#login", as: :login, via: [:get, :post]
  end
  
end
