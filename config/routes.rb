Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :nodes, only: :create
    resources :templates, only: :index
    resources :sections, only: :index

    post '/linters' => 'linters#parse', :as => :parse_content
  end

  get root 'sections#index'
  get '/:section' => 'sections#show', as: :sections
  get '/:section(/*path)' => 'nodes#show', as: :nodes
end
