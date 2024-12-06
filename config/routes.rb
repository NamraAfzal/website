Rails.application.routes.draw do
  get 'pages/contact'
  resources :products, only: %i[index show]
  resources :categories, only: %i[index show]
  namespace :sellers do
    resources :products
    resources :dashboard, only: :index
    resources :orders, only: %i[index show edit update]
  end
  resources :order_items, only: %i[ index show create destroy ]do
  patch :update_quantity, on: :member
  end
  get '/cart', to: 'orders#show_cart'
  post '/place_order', to: 'orders#place_order', as: :place_order
  resources :orders, only: %i[index show create] do
    collection do
      get :seller_orders
    end
    member do
      post :add_to_cart
      delete :remove_from_cart
      patch :place_order
      post :checkout
    end
  end

  get 'contact', to: 'pages#contact', as: 'contact'

  devise_for :sellers, path: 'sellers'
  devise_for :users, path: 'users',controllers: {
    registrations: 'users/registrations'
  }

  root to: "home#index"
end
