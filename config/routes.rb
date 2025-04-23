Rails.application.routes.draw do
  get "stripe_payments/create"
  get "profiles/edit"
  get "profiles/update"
  # Devise routes for customer users
  devise_for :users, controllers: {
    sessions: 'users/sessions'
  }
  

  # Devise routes for admin (ActiveAdmin)
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)

  # Health Check & PWA
  get "up" => "rails/health#show", as: :rails_health_check
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest

  # Cart routes (custom)
  get "/cart", to: "cart#show", as: "cart"
  post "/cart/add", to: "cart#add", as: "add_to_cart"
  patch "/cart/update", to: "cart#update", as: "update_cart"
  delete "/cart/remove", to: "cart#remove", as: "remove_from_cart"

  post 'orders/:id/checkout', to: 'orders#checkout', as: 'checkout_order'
  get 'orders/payment_success', to: 'orders#payment_success'
  get 'orders/payment_cancel', to: 'orders#payment_cancel'
  get '/create-checkout-session/:order_id', to: 'stripe_payments#create', as: 'create_checkout_session'


  # Orders
  resources :orders, only: [:new, :create, :show]

  # Product and Category routes
  resources :products, only: [:index, :show]
  resources :categories, only: [:index, :show]
# config/routes.rb
  resource :profile, only: [:edit, :update]

  # Static pages
  get "/about", to: "static_pages#show", defaults: { id: 'about' }, as: :about_page
  get "/contact", to: "static_pages#show", defaults: { id: 'contact' }, as: :contact_page
  get "/pages/:id", to: "static_pages#show", as: "static_page"

  # Root path
  root "products#index"
end
