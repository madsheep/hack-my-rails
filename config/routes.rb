Takeit::Application.routes.draw do

  resources :hacks

  root to: 'hacks#index'

end
