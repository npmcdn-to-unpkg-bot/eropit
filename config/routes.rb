Rails.application.routes.draw do

  root 'home#index'
  resources :articles
  get 'admin', to: 'articles#manage' 

end
