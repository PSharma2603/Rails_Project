Rails.application.routes.draw do
  devise_for :users
  get "orders/new"
  get "orders/create"
  get "cart/show"
  get "cart/add"
  get "cart/remove"
  get "cart/update"
  get "static_pages/show"
  get "products/index"
  get "products/show"
  get "/cart", to: "cart#show", as: "cart"
  post "/cart/add", to: "cart#add", as: "add_to_cart"
  patch "/cart/update", to: "cart#update", as: "update_cart"
  delete "/cart/remove", to: "cart#remove", as: "remove_from_cart"

  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Health check & PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Root path
  root 'products#index'

  # Product & category routes
  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]
  resources :orders, only: [:new, :create, :show]


  # ✅ Static Pages (newly added)
  get "/about", to: "static_pages#show", defaults: { id: 'about' }, as: :about_page
  get "/contact", to: "static_pages#show", defaults: { id: 'contact' }, as: :contact_page
  get "/pages/:id", to: "static_pages#show", as: "static_page"
end
