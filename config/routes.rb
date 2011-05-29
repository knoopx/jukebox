Jukebox::Application.routes.draw do
  ActiveAdmin.routes(self)
#  resources :releases
#  resources :artists
#  resources :genres do
#    resources :artists
#  end
  resources :tracks do
    member do
      get :stream
    end
  end
end
