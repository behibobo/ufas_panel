Rails.application.routes.draw do
  resources :plans
  namespace :admin do
    resources :servers, except: [:index]
    post 'server/get_all', to: "servers#index"
    get 'countries', to: "api#countries"
    resources :plans
    post 'users/get_all', to: "users#index"
    get 'users/:id', to: "users#show"
    post "signin", to: "admin_auth#signin"
    get "countries", to: "servers#countries"
  end

  namespace :api do
    get "account", to: "api#account"
    get "create_country", to: "api#create_country"
    get "referrer/:code", to: "api#referrer"
    get "servers", to: "api#servers"
    get "plans", to: "api#plans"
    post "email_exists", to: "api#email_exists"
    post "user_server", to: "api#user_server"
    get 'auto_server', to: "api#auto_server"
  end

  post "signin", to: "auth#signin"
  post "activate", to: "auth#activate"
  post "uuid_signin", to: "auth#uuid_signin"
  post "signup", to: "auth#signup"
  post "forget_password", to: "auth#forget_password"
  post "validate_code", to: "auth#validate_code"
  post "change_password", to: "auth#change_password"
  
end
