Rails.application.routes.draw do
  resources :order_books
  resources :news
  resources :trades
  resources :orders
  resources :securities
  devise_for :users
  resources :users
  root to: "home#index"
end
