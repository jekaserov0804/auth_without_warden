Rails.application.routes.draw do

  scope constraints: lambda { |r| r.env['warden'].user.nil? } do
    get "sign_up", to: "users#new", as: "sign_up"
    get "log_in", to: "sessions#new", as: "log_in"
  end
  get "log_out" => "sessions#destroy", as: "log_out"
  resources :users
  resources :sessions
  root to: 'session#new'
  get '/secret', to: 'home#index', as: 'secret'
end
