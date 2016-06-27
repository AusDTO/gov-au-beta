Rails.application.routes.draw do
  devise_for :users

  namespace :editorial do
    resources :nodes, only: [:show, :create, :new, :edit, :update, :index] do
      get 'prepare', on: :collection
      resources :submissions, shallow: true
    end

    get '/submissions' => 'submissions#index', as: 'user_submissions'
    get '/:section/submissions' => 'submissions#index', as: 'section_submissions'
    resources :requests, only: [:create, :new, :index, :show, :update]
    get '/:section' => 'sections#show', as: 'section'
    get '/:section/collaborators' => 'sections#collaborators', as: 'collaborators'
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
