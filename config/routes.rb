Rails.application.routes.draw do
  resources :products, only: [:index]
  namespace :sellers do
    resources :products
    resources :orders, only: [:index, :show]
  end

  namespace :users do
    root to: "dashboard#index"
  end

  devise_for :sellers, path: 'sellers'
  devise_for :users, path: 'users'

  resources :carts, only: [:show] do
    member do
      delete 'remove_from_cart/:product_id', to: 'carts#remove_from_cart', as: 'remove_from_cart'
    end
    post 'add_to_cart/:product_id', to: 'carts#add_to_cart', as: 'add_to_cart'
  end

  root to: "home#index"
end
