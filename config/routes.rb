Rails.application.routes.draw do
  resources :positions
  resources :statements
  resources :order_books
  resources :news
  resources :trades
  resources :orders
  resources :securities
  devise_for :users
  resources :users
  root to: "home#index"
end
