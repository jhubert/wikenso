Wikenso::Application.routes.draw do
  resources :wikis, :only => [:new, :create]
  scope :constraints => { :subdomain => /.+/ } do
    resources :sessions, :only => [:new, :create, :destroy]
    get "/" => "wikis#show"
  end
  root :to => 'wikis#new'
end
