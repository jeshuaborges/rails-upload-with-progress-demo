RailsUploadWithProgressDemo::Application.routes.draw do
  resources :uploads, only: :create
end
