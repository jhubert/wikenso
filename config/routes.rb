Wikenso::Application.routes.draw do
  resources :wikis, only: [:new, :create]
  scope constraints: {:subdomain => /.+/} do
    resources :users, only: [:index]
    resources :pending_users, only: [:update, :create]
    post 'user_invitation_emails/:user_id' => "user_invitation_emails#create", as: 'resend_invitation_email'
    get '/redeem/:invitation_code' => "pending_users#edit", as: 'redeem_invitation_code'

    get "/settings" => "wikis#edit"
    resources :sessions, only: [:new, :create, :destroy]
    resources :pages, only: [:show, :edit, :new, :create]
    get "/" => "pages#show"
  end
  root :to => 'wikis#new'

  namespace :api do
    namespace :v1 do
      resources :pages, only: :update
    end
  end
end
