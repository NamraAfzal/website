Rails.application.routes.draw do
  get 'pages/contact'
  resources :products, only: %i[index show]
  resources :categories, only: %i[index show]
  namespace :sellers do
    resources :products
    get 'dashboard', to: 'dashboard#index', as: 'dashboard'
    resources :orders, only: %i[index show update]
  end

  namespace :users do
    root to: "dashboard#index"
  end

  resources :order_items, only: %i[ index create destroy ]
  get '/cart', to: 'orders#show_cart'
  post '/place_order', to: 'orders#place_order', as: :place_order
  resources :orders, only: %i[index show] do
    collection do
      get :seller_orders
    end
    member do
      post :add_to_cart
      delete :remove_from_cart
      patch :place_order
    end
  end

  get 'contact', to: 'pages#contact', as: 'contact'

  devise_for :sellers, path: 'sellers'
  devise_for :users, path: 'users',controllers: {
    registrations: 'users/registrations'
  }
  post "checkout/create", to: "checkout#create"


  root to: "home#index"
end
