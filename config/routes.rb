Wikenso::Application.routes.draw do
  resources :wikis, only: [:new, :create]
  scope constraints: {:subdomain => /.+/} do
    resources :users, only: [:index, :create]
    resources :pending_users, only: [:update]
    get '/redeem/:invitation_code' => "pending_users#edit", as: 'redeem_invitation_code'

    get "/settings" => "wikis#edit"
    resources :sessions, only: [:new, :create, :destroy]
    resources :pages, only: [:show, :edit]
    get "/" => "pages#show"
  end
  root :to => 'wikis#new'

  namespace :api do
    namespace :v1 do
      resources :pages, only: :update
    end
  end
end
