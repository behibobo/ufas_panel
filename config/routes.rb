Rails.application.routes.draw do
  resources :plans

  namespace :admin do
    resources :servers, except: [:index]
    resources :plans
    post 'server/get_all', to: "servers#index"
    post 'account/get_all', to: "accounts#index"
    get 'countries', to: "api#countries"
    post 'users/get_all', to: "users#index"
    get 'users/:id', to: "users#show"
    post "signin", to: "admin_auth#signin"
    get "countries", to: "servers#countries"
    get 'dashboard/plans', to: 'api#plans_purchased'
    post 'dashboard/accounts', to: 'api#accounts'
    get 'dashboard/recent_accounts', to: 'api#recent_accounts'
    get 'dashboard/user_servers', to: 'api#user_servers'
    get 'dashboard/dates', to: 'api#dates'
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
  post "validate_referral", to: "auth#validate_referral"


  namespace :front do
    post 'signup', to: "auth#signup"
    post 'signin', to: "auth#signin"
    post 'activate', to: "auth#activate"
    get 'profile', to: "accounts#index"
    get 'plans', to: 'plans#index'
  end
  
end
