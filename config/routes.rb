Rails.application.routes.draw do
  root "players#index"
  # get "/players", to: "players#index"
  # get "/players/:id", to: "players#show"
  resources :players
end
