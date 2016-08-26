Rails.application.routes.draw do

  root 'home#index'
  resources :articles, except: [:index]
  resources :categories

  get 'admin', to: 'articles#manage'

end
