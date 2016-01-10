Rails.application.routes.draw do

  mount ChinaCity::Engine => '/china_city'
  resources :pigs
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # devise_for :users
  devise_for :users, controllers: { registrations: "reg", sessions: "login", passwords:"passwds"}
  devise_scope :user do
    get 'promotion/:id' => 'reg#promotion'
    get 'forget' => 'reg#forget'
    post 'fill_pass' => 'reg#fill_pass'
    post 'reset_pass' => 'reg#reset_pass'
    get 'logout' => 'login#destroy'
    post "get_code" => "reg#get_code"

    post "get_code_forget" => "reg#get_code_forget"
    post "/checkmobile" => "reg#checkmobile"
    post "/check_forget_code" => "reg#check_forget_code"
    post "/checkmobile_exist" => "reg#checkmobile_exist"
  end
  # devise_for :users, :controllers => {:registrations => "reg"}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'front#index'
  root 'front#index'
  get 'front' => "front#index"
  get 'advice' => "front#advice"
  get 'brand' => "front#brand"
  get 'benefit' => "front#benefit"
  get 'member' => "front#member"
  get 'logout' => "login#destroy"
  get 'charge' => "users#charge"
  post 'charge_account' => "users#charge_account"
  # Example of regular route:
  get 'profile' => 'users#profile'
  get 'error' => 'products#error'
  get 'password' => 'users#password'
  post 'change_pass' => 'users#change_pass'
  get 'products' => 'products#index'
  get 'orders' => 'orders#index'
  get 'news' => 'news#index'
  get 'alipay_route/:order' => 'orders#show_order', :as => "alipay_route"
  get 'charge_return/:order' => 'orders#charge_return', :as => "charge_return"
  get 'charge_notify/:order' => 'orders#charge_notify', :as => "charge_notify"
  get 'alipay_return/:order' => 'orders#alipay_return', :as => "alipay_return"
  get 'alipay_notify/:order' => 'orders#alipay_notify', :as => "alipay_notify"


  get 'process_order/:id' => 'admin/orders#finish'
  get 'payback/:uid/:anatype/:year/:mon' => 'admin/users#payback'
  get 'paycoupon/:uid/:year' => 'admin/users#paycoupon'
  get 'members' => 'products#members'
  # get 'reg' => 'reg#new'
  post 'newaccount' => 'reg#create'


  # get 'logout' => 'users#logout'
  get 'payment' => 'orders#payment'
  post 'notice/:id' => 'users#notice'
  # get 'logout' => 'users#logout'
  get 'store' => 'store#index'
  post 'request_store' => 'store#req_store'
  get 'request_dealer' => 'store#req_dealer'
  get 'put_store' => 'store#put_store'
  post 'push_store' => 'store#push_store'

  post 'alipay_order' => "orders#alipay"


  get 'storecart' => 'store#storecart'
  get 'store_orders' => 'store#orders'
  get 'store_list' => 'store#list'
  get 'sent_list' => 'store#sent'
  get 'store_order_detail' => 'store#store_order_detail'

  get 'network' => 'network#index'
  post 'network_create' => 'network#create'

  # Example of named route that can be invoked with purchase_url(id: products.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :users
  resource :cart do
    member do
      get 'delete_item'
      get 'delete_store'
    end
  end

  resources :products do
    member do
      post 'buy'
    end
  end

  resources :store do
    member do
      post 'addcart'

    end
  end





  resources :orders do
    member do
      # post 'alipay'
      post 'store'

    end
  end

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
end
