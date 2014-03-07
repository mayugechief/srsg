# coding: utf-8
class ActionDispatch::Routing::Mapper
  
  def content(ns, &block)
    name = ns.gsub("/", "_")
    namespace(name, path: ".:host/#{ns}:cid", module: ns, cid: /\w+/) { yield }
  end
  
  def node(ns, &block)
    alias :plugin :node_plugin
    alias :addon :node_addon
    @ns  = ns
    name = ns.gsub("/", "_")
    path = ".:host/node/#{ns}"
    namespace(name, as: "node_#{name}", path: path, module: "cms") { yield }
  end
  
  def part(ns, &block)
    alias :plugin :part_plugin
    alias :addon :part_addon
    @ns  = ns
    name = ns.gsub("/", "_")
    path = ".:host/part/#{ns}"
    namespace(name, as: "part_#{name}", path: path, module: "cms") { yield }
  end
  
  def page(ns, &block)
    alias :addon :page_addon
    @ns  = ns
    yield
  end
  
  def node_plugin(name)
    Cms::Node.plugin @ns, name
  end
  
  def part_plugin(name)
    Cms::Part.plugin @ns, name
  end
  
  def node_addon(name)
    Cms::Node.addon @ns, name
  end
  
  def part_addon(name)
    Cms::Part.addon @ns, name
  end
  
  def page_addon(name)
    klass = "#{@ns}/addon/#{name}".camelize
    Cms::Page.include klass.constantize
    Article::Page.include klass.constantize #TODO:
  end
end

SS::Application.routes.draw do
  
  concern :deletion do
    get :delete, :on => :member
  end
  
  namespace "sns", path: ".mypage" do
    get   "/"      => "mypage#index", as: :mypage
    get   "logout" => "login#logout", as: :logout
    match "login"  => "login#login", as: :login, via: [:get, :post]
  end
  
end
