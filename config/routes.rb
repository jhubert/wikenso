Wikenso::Application.routes.draw do
  resources :wikis, :only => [:new, :create]
  get "/" => "wikis#show", :constraints => { :subdomain => /.+/ }
  root :to => 'wikis#new'
end
