Rails.application.routes.draw do
  concern :paginatable do
    get '(page/:page)', :action => :index, :on => :collection, :as => ''
  end

  match "/404", :to => "errors#not_found", :via => :all
  match "/422", :to => "errors#change_rejected", :via => :all
  match "/500", :to => "errors#internal_server_error", :via => :all

  devise_for :users, controllers: { confirmations: 'confirmations', :sessions => "sessions" }, skip: [:registrations]
  as :user do
    get 'users/edit' => 'registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'registrations#update', :as => 'user_registration'
  end

  namespace :users do
    resource :two_factor_setup, only: [:index], controller: 'two_factor_setup' do
      get :index
      post :choice
      get :continue_setup

      resource :authenticator, only: [:new, :create, :update], controller: 'two_factor_setup/authenticator_setup' do
        post :resend_code
      end

      resource :sms, only: [:new, :create, :update], controller: 'two_factor_setup/sms_setup' do
        post :resend_code
        get :confirm
      end
    end

    resource :two_factor_verification, only: [:new, :create, :update], controller: :two_factor_verification do
      post :resend_code
      get :confirm
    end
  end

  resource :feedback, controller: 'feedback'

  namespace :editorial do
    resources :assets, only: [:index, :new, :create, :update, :edit], :concerns => :paginatable
    resources :news, only: [:index, :new, :edit, :update]
    get '/:section/news/:slug' => 'news#show', as: :news_article

    post '/news' => 'news#create'

    resources :users, only: [:new, :create]

    get ':section_id' => 'sections#show', as: 'section'
    scope ':section_id', as: 'section' do
      resources :submissions
      resources :requests, only: [:new, :create, :show, :update]
      get 'collaborators' => 'sections#collaborators', as: 'collaborators'

      resources :nodes, only: [:show, :create, :new, :edit, :update, :index] do
        get 'prepare', on: :collection
      end
    end

    root to: 'editorial#index'
  end

  namespace :admin do
    root to: 'agencies#index'

    # keep these alphabetically sorted
    # code order determines order in the UI
    resources :agencies
    resources :assets
    resources :categories
    resources :custom_template_nodes
    resources :departments
    resources :feedbacks
    resources :general_contents
    resources :invites
    resources :ministers
    resources :news_articles
    resources :nodes
    resources :requests
    resources :revisions
    resources :roles
    resources :root_nodes

    resources :sections do
      member do
        post 'import'
      end
    end

    resources :section_homes
    resources :sessions
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
  resources :invites, only: [:show, :create, :new, :edit, :update] do
    collection do
      get :required
    end
  end

  get 'categories/:slug' => 'categories#show', as: :category

  get root 'nodes#home'
  get '/preview/:token' => 'nodes#preview', as: :previews

  get '/news' => 'news#index', as: :news_articles
  get '/:section/news' => 'news#index', as: :section_news_articles
  get '/:section/news/:slug' => 'news#show', as: :news_article

  get '/*path' => 'nodes#show', as: :nodes

end
