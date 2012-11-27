RailsUploadWithProgressDemo::Application.routes.draw do
  resources :photos, only: [:new, :create, :index]
  resources :uploads, only: :create
end
