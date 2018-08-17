Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "registers#index"

  resources :vehicles
  resources :drivers
  resources :maintenances, except: :index do
    post "multiple", to: "maintenances#create_multiple", on: :collection, as: "multiple"
  end
  get 'maintenances', to: 'maintenances#index'

  resources :registers, except: :index do
    post "multiple", to: "registers#create_multiple", on: :collection, as: "multiple"
    get "print", to: "registers#print", on: :collection, as: "print"
  end
  get 'registers', to: 'registers#index'

  post "utils/change_vehicle", to: "utils#change_current_vehicle", as: 'change_vehicle'
end
