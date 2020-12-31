Rails.application.routes.draw do
  namespace :admin do
    resources :servers
    post "signin", to: "admin_auth#signin"
  end
  post "signin", to: "auth#signin"
  post "signup", to: "auth#signup"
end
