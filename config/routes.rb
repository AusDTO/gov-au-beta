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
    root to: 'agencies#index'
    resources :agencies do
      member do
        post 'import'
      end
    end

    resources :departments
    resources :general_contents
    resources :ministers
    resources :news_articles
    resources :nodes
    resources :requests
    resources :revisions
    resources :roles
    resources :root_nodes
    resources :section_homes
    resources :sections
    resources :submissions
    resources :topics
    resources :users
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :nodes, only: :create
    resources :templates, only: :index
    resources :sections, only: :index
  end

  resources :departments, only: :index

  get root 'nodes#show'
  get '/preview/:token' => 'nodes#preview', as: :previews
  get '/*path' => 'nodes#show', as: :nodes
end
