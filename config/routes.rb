Rails.application.routes.draw do
  post "/sigin", to: "auth#sigin"
  post "/signup", to: "auth#signup"
end
