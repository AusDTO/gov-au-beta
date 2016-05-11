Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :nodes, only: :create
  end

  get '/:section' => 'sections#show', as: :sections
  get '/:section(/*path)' => 'nodes#show', as: :nodes
end
