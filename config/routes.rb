Rails.application.routes.draw do
  devise_for :users

  namespace :editorial do
    get '/:section/nodes' => 'nodes#index'
    resources :nodes, only: [:show, :create, :new, :edit, :update]
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
  get '/preview/:token' => 'nodes#preview', as: :previews
  get '/:section' => 'sections#show', as: :sections
  get '/:section(/*path)' => 'nodes#show', as: :nodes

end
