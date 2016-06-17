Rails.application.routes.draw do
  devise_for :users

  namespace :editorial do
    #resources :sections, only: [:index]
    resources :nodes, only: [:show, :create, :new, :edit, :update, :index] do
      get 'prepare', on: :collection
    end
    get '/:section' => 'sections#show', as: 'section'
    root to: 'editorial#index'
  end

  namespace :admin do
    resources :agencies
    resources :topics
    resources :nodes
    resources :general_contents
    resources :news_articles
    resources :sections
    resources :users

    root to: 'agencies#index'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :nodes, only: :create
    resources :templates, only: :index
    resources :sections, only: :index
  end
  mount Synergy::Engine => "/api"

  get root 'sections#index'
  get '/preview/:token' => 'nodes#preview', as: :previews
  get '/:section' => 'sections#show', as: :sections
  get '/:section(/*path)' => 'nodes#show', as: :nodes



end
