Synergy::Engine.routes.draw do

  get root 'pages#show'

  get '/*path' => 'pages#show', as: :pages

end
