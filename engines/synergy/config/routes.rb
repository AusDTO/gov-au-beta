Synergy::Engine.routes.draw do

  get root 'pages#index'

  get '/*path' => 'pages#show', as: :pages

end
