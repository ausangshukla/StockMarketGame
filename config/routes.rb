Rails.application.routes.draw do
  resources :news
  resources :trades
  resources :orders
  resources :securities
  devise_for :users
  resources :users
  root to: "home#index"
end
