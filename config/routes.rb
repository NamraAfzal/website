Rails.application.routes.draw do
  resources :products, only: :index
  namespace :sellers do
    resources :products
    resources :orders, only: %i[index show]
    root to: "dashboard#index"
  end

  namespace :users do
    root to: "dashboard#index"
  end

  resources :orders, only: %i[index show] do
    member do
      post :add_to_cart
      delete :remove_from_cart
      patch :place_order
    end
  end

  devise_for :sellers, path: 'sellers'
  devise_for :users, path: 'users'
  get '/seller_dashboard', to: 'sellers/dashboard#index', as: 'seller_dashboard'

  root to: "home#index"
end
