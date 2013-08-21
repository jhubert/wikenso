Wikenso::Application.routes.draw do
  resources :wikis, :only => [:new, :create]
  scope :constraints => { :subdomain => /.+/ } do
    resources :sessions, :only => [:new, :create, :destroy]
    resources :pages, :only => [:show, :edit]
    get "/" => "pages#show"
  end
  root :to => 'wikis#new'

  namespace :api do
    namespace :v1 do
      resources :pages, only: :update
    end
  end
end
