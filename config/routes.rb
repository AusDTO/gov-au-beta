Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :nodes, only: :create
  end

  #resources :nodes
  get '/:section(/*path)' => 'nodes#show'
end
