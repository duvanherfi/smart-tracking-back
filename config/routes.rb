Rails.application.routes.draw do
  resources :users

  namespace :api do
    namespace :v1 do
      resources :users
      resources :sessions do
        collection do
          post :login
          delete :logout
        end
      end
    end
  end

  resources :home, only: [:index]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#index"

  namespace :turbo do
    namespace :android do
      resource :path_configuration, only: :show
    end
    namespace :ios do
      resource :path_configuration, only: :show
    end
  end
end
