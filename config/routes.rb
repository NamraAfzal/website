Rails.application.routes.draw do
  resources :products, only: [:index]
  namespace :sellers do
    resources :products
    resources :orders, only: [:index, :show]
    root to: "dashboard#index"
  end

  namespace :users do
    root to: "dashboard#index"
  end
  resources :carts, only: [:index, :show] do
    post 'add_to_cart', on: :member
    delete 'remove_from_cart', on: :member
  end

  devise_for :sellers, path: 'sellers'
  devise_for :users, path: 'users'
  get '/seller_dashboard', to: 'sellers/dashboard#index', as: 'seller_dashboard'

  root to: "home#index"
end
