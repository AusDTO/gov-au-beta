Synergy::Engine.routes.draw do

  resources :events, only: [:create, :show, :index]

end
