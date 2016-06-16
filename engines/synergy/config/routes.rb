Synergy::Engine.routes.draw do

  get '*path' => 'pages#show', as: :pages

end
