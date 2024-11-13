Rails.application.routes.draw do
  namespace :sellers do
    resources :products
    resources :orders, only: [:index, :show]
    root to: "dashboard#index"
  end

  namespace :users do
    root to: "dashboard#index"
  end

  devise_for :sellers, path: 'sellers'
  devise_for :users, path: 'users'
  get '/seller_dashboard', to: 'sellers/dashboard#index', as: 'seller_dashboard'


  root to: "home#index"
end
