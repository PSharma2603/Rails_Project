Rails.application.routes.draw do
  get "static_pages/show"
  get "products/index"
  get "products/show"
  
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

  # ✅ Static Pages (newly added)
  get "/about", to: "static_pages#show", defaults: { id: 'about' }, as: :about_page
  get "/contact", to: "static_pages#show", defaults: { id: 'contact' }, as: :contact_page
  get "/pages/:id", to: "static_pages#show", as: "static_page"
end
