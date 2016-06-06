Rails.application.routes.draw do
  devise_for :users

  namespace :editorial do
    resources :nodes, only: [:create, :new]
    get '/:section/nodes' => 'nodes#index'
    get '/nodes/:token' => 'nodes#show'
  end

  namespace :admin do
    resources :agencies
    resources :topics
    resources :nodes
    resources :content_blocks
    resources :sections

    root to: 'agencies#index'
  end

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :nodes, only: :create
    resources :templates, only: :index
    resources :sections, only: :index
  end

  get root 'sections#index'
  get '/:section' => 'sections#show', as: :sections

  scope :editorial do
    resources :nodes, only: [:create, :new, :edit, :update], as: :editorial_nodes
  end

  get '/:section(/*path)' => 'nodes#show', as: :nodes

end
