Rails.application.routes.draw do
  resources :pigs
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  # devise_for :users
  devise_for :users, controllers: { registrations: "reg", sessions: "login", passwords:"passwds"}
  devise_scope :user do
    get 'promotion/:id' => 'reg#promotion'
  end
  # devise_for :users, :controllers => {:registrations => "reg"}
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'front#index'
  root 'about#about'
  get 'front' => "front#index"
  # Example of regular route:
  get 'profile' => 'users#profile'
  get 'products' => 'products#index'
  get 'orders' => 'orders#index'
  get 'news' => 'news#index'
  # get 'reg' => 'reg#new'
  post 'newaccount' => 'reg#create'


  # get 'logout' => 'users#logout'
  get 'payment' => 'orders#payment'
  # get 'logout' => 'users#logout'
  get 'store' => 'store#index'
  get 'request_store' => 'store#req_store'
  get 'put_store' => 'store#put_store'
  post 'push_store' => 'store#push_store'
  get 'network' => 'network#index'
  post 'network_create' => 'network#create'

  # Example of named route that can be invoked with purchase_url(id: products.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  resources :users
  resource :cart do
    member do
      get 'delete_item'
    end
  end

  resources :products do
    member do
      post 'buy'
    end
  end





  resources :orders do
    member do
      get 'alipay'
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
