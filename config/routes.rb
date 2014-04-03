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
  
  def part(ns, &block)
    name = ns.gsub("/", "_")
    path = ".:host/part/#{ns}"
    namespace(name, as: "part_#{name}", path: path, module: "cms") { yield }
  end
end

SS::Application.routes.draw do
  
  SS::Prep
  
  concern :deletion do
    get :delete, :on => :member
  end
  
  namespace "fs" do
    get "*path" => "files#index"
  end
  
  namespace "sns", path: ".mypage" do
    get   "/"      => "mypage#index", as: :mypage
    get   "logout" => "login#logout", as: :logout
    match "login"  => "login#login", as: :login, via: [:get, :post]
  end
  
  namespace "sns_user", path: ".u:user", module: "sns/user" do
    resources :files, concerns: :deletion do
      get :view, on: :member
      get :thumb, on: :member
      get :download, on: :member
    end
  end
  
end
