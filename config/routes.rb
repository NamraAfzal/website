Rails.application.routes.draw do
  namespace :sellers do
    root to: "dashboard#index"
  end

  namespace :users do
    root to: "dashboard#index"
  end

  devise_for :sellers, path: 'sellers', controllers: {

  }

  devise_for :users, path: 'users', controllers: {

  }

  root to: "home#index"
end
