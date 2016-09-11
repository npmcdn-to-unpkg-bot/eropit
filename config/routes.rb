Rails.application.routes.draw do

  root 'home#index'
  resources :articles, except: [:index] do
    collection do
      get 'ranking'
      get 'search'
      get 'favorites'
    end
  end

  resources :tags
  
  get 'admin', to: 'articles#manage'
  get 'fetch/nukistream', to: 'articles#nukistream'
  get 'fetch/masutabe', to: 'articles#masutabe'
  get 'feed', to: 'articles#feed', format: 'rss'
end
