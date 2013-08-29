Wikenso::Application.routes.draw do
  resources :wikis, only: [:new, :create]
  scope constraints: {:subdomain => /.+/} do
    resources :users, only: [:index]
    resources :pending_users, only: [:create]
    post 'user_invitation_emails/:user_id' => "user_invitation_emails#create", as: 'resend_invitation_email'

    get '/redeem/:invitation_code' => "pending_users#edit", as: 'redeem_invitation_code'
    put '/redeem/:invitation_code' => "pending_users#update"

    get "/settings" => "wikis#edit"

    resources :sessions, only: [:new, :create]
    delete "/logout" => "sessions#destroy", as: :logout

    resources :pages, except: [:index, :destroy] do
      resources :page_versions, only: [:index], as: :changes, path: :changes
    end

    resources :draft_pages, only: [:destroy]
    get "/" => "pages#show"
  end
  root :to => 'wikis#new'

  namespace :api do
    namespace :v1 do
      resources :draft_pages, only: :update
    end
  end
end
