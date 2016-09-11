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
  get 'fetch', to: 'articles#fetch'
  get 'admin', to: 'articles#manage'
  get 'feed', to: 'articles#feed', format: 'rss'
end
