Rails.application.routes.draw do
  resources :plans
  namespace :admin do
    resources :servers
    post "signin", to: "admin_auth#signin"
    get "countries", to: "servers#countries"
  end

  namespace :api do
    get "account", to: "api#account"
    get "create_country", to: "api#create_country"
    get "referrer/:code", to: "api#referrer"
    get "servers", to: "api#servers"
    post "email_exists", to: "api#email_exists"
  end

  post "signin", to: "auth#signin"
  post "uuid_signin", to: "auth#uuid_signin"
  post "signup", to: "auth#signup"
end
