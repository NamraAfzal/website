Rails.application.routes.draw do
  resources :products, only: %i[index show]
  namespace :sellers do
    resources :products
    resources :downloads, only: %i[index create]
    resources :dashboard, only: :index
    resources :orders, only: %i[index show edit update]
  end
  resources :order_items, only: %i[create destroy]do
  patch :update_quantity, on: :member
  end
  post '/place_order', to: 'orders#place_order', as: :place_order
  resources :orders, only: %i[index show create] do
    member do
      post :checkout
      get '/payment', to: 'orders#payment', as: :payment
      get :invoice
    end
  end
  get 'contact', to: 'pages#contact', as: 'contact'

  devise_for :sellers, path: 'sellers'
  devise_for :users, path: 'users',controllers: {
    registrations: 'users/registrations'
  }

  namespace :api do
    products_routes = -> do
      resources :products, only: %i[index show]
    end
    namespace :users do
      devise_scope :user do
        post 'login', to: 'sessions#create', as: :login
        delete 'logout', to: 'sessions#destroy', as: :logout
      end

      instance_exec(&products_routes)
    end

    namespace :sellers do
      devise_scope :seller do
        post 'login', to: 'sessions#create', as: :login
        delete 'logout', to: 'sessions#destroy', as: :logout
      end
      resources :orders
    end
    resources :products
    resources :dashboard, only: :index
    resources :order_items do
      member do
        patch :update_quantity
      end
    end
    resources :orders do
      member do
        post :place_order
        post :checkout
        get :payment
      end
    end
  end

  root to: "home#index"
end
