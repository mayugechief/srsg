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
  
  Cms::Node.route "node/none"
  Cms::Part.route "cms/frees"
  
  Cms::Page.addon "cms/basic"
  Cms::Page.addon "cms/html"
  Cms::Page.addon "cms/tiny"
  Cms::Page.addon "cms/wiki"
  
  concern :deletion do
    get :delete, :on => :member
  end
  
  namespace "sns", path: ".mypage" do
    get   "/"      => "mypage#index", as: :mypage
    get   "logout" => "login#logout", as: :logout
    match "login"  => "login#login", as: :login, via: [:get, :post]
  end
  
  namespace "sys", path: ".sys" do
    get "/" => "main#index", as: :main
    get "test" => "test#index", as: :test
    resources :users, concerns: :deletion
    resources :groups, concerns: :deletion
    resources :sites, concerns: :deletion
  end
  
  namespace "cms", path: ".:host" do
    get "/" => "main#index", as: :main
    #get "/" => "contents#index", as: :main
  end
  
  namespace "cms", path: ".:host/cms" do
    get "/" => "main#index"
    resources :contents, path: "contents/(:mod)"
    resources :nodes, concerns: :deletion
    resources :pages, concerns: :deletion
    resources :parts, concerns: :deletion
    resources :layouts, concerns: :deletion
    resources :roles, concerns: :deletion
  end
  
  # ----------------------------------------------------------------------------

  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end
  
  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end

  # ----------------------------------------------------------------------------
end
