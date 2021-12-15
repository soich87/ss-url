Rails.application.routes.draw do
  root 'shorten_urls#index'
  devise_for :users
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  get '/:url_code', to: 'shorten_urls#redirection', as: 'redirection'
  resources :shorten_urls
end
