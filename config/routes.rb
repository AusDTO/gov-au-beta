Rails.application.routes.draw do
  devise_for :users

  namespace :editorial do

    get ':section_id' => 'sections#show', as: 'section'
    scope ':section_id', as: 'section' do
      resources :submissions
      resources :requests
      get 'collaborators' => 'sections#collaborators', as: 'collaborators'

      resources :nodes, only: [:show, :create, :new, :edit, :update, :index] do
        get 'prepare', on: :collection
      end
    end

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
    resources :roles
    resources :requests
    resources :submissions
    resources :revisions

    root to: 'agencies#index'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :nodes, only: :create
    resources :templates, only: :index
    resources :sections, only: :index
  end

  get root 'sections#index'
  get '/preview/:token' => 'nodes#preview', as: :previews
  get '/:section' => 'sections#show', as: :section
  get '/:section(/*path)' => 'nodes#show', as: :nodes



end
