Wikenso::Application.routes.draw do
  resources :wikis, :only => [:new, :create]
  scope :constraints => { :subdomain => /.+/ } do
    resources :sessions, :only => [:new, :create, :destroy]
    resources :pages, :only => [:show]
    get "/" => "pages#show"
  end
  root :to => 'wikis#new'
end
