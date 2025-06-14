Rails.application.routes.draw do

  get "legal", to: "legal#index", format: "pdf"

  namespace :api do
    namespace :v1, defaults: { format: "json" } do
      resources :users
      resources :sessions do
        collection do
          post :login
          delete :logout
        end
      end
      resources :vehicles, only: [ :index, :show ] do
        member do
          get :recommended
        end
      end
      resources :geo_fences
      resources :notifications, only: [ :index, :show ] do
        member do
          put :toggle_enabled
        end
      end
    end
  end

  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "home#index"
end
