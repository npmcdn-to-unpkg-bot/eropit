Rails.application.routes.draw do

  root 'home#index'
  resources :articles, except: [:index] do
    collection do
      get 'ranking'
      get 'search'
    end
  end
  get 'admin', to: 'articles#manage'
  get 'fetch/nukistream', to: 'articles#nukistream'
end
