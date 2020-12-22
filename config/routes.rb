Rails.application.routes.draw do
  post "signin", to: "auth#signin"
  post "signup", to: "auth#signup"
end
