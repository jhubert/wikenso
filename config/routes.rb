Wikenso::Application.routes.draw do
  resources :wikis, :only => [:new, :create]
  scope :constraints => lambda { |request| Wiki.case_insensitive_find_by_name(request.subdomain).present? } do
    get "/" => "wikis#show"
  end
  root :to => 'wikis#new', :constraints => { :subdomain => "" }
end
