Rails.application.routes.draw do

  root 'home#index'
  resources :articles, except: [:index] do
    collection do
      get 'ranking'
    end
  end
  resources :categories

  get 'admin', to: 'articles#manage'
end
