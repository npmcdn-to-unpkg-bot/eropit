Rails.application.routes.draw do

  root 'home#index'
  resources :articles, except: [:index]
  get 'admin', to: 'articles#manage'

end
