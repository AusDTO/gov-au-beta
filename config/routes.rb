Rails.application.routes.draw do
  devise_for :users

  namespace :editorial do
    resources :news, only: [:index, :new, :edit, :update]
    get '/:section/news/:slug' => 'news#show', as: :news_article

    post '/news' => 'news#create'

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
    resources :custom_template_nodes
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
  resources :ministers, only: :index

  #FIXME Hard-coded category routes - static content
  get 'categories/infrastructure-and-telecommunications' => 'categories#infrastructure_and_telecommunications'

  get root 'nodes#home'
  get '/preview/:token' => 'nodes#preview', as: :previews

  get '/news' => 'news#index', as: :news_articles
  get '/:section/news' => 'news#index', as: :section_news_articles
  get '/:section/news/:slug' => 'news#show', as: :news_article

  get '/*path' => 'nodes#show', as: :nodes
end
