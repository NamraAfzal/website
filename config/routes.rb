Rails.application.routes.draw do
  resources :products, only: %i[index show]
  namespace :sellers do
    resources :products
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
    end
  end
  get 'contact', to: 'pages#contact', as: 'contact'

  devise_for :sellers, path: 'sellers'
  devise_for :users, path: 'users',controllers: {
    registrations: 'users/registrations'
  }

  root to: "home#index"
end
