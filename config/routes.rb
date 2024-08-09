Rails.application.routes.draw do
  devise_for :users, path: 'auth'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root to: "registers#index"

  resources :vehicles do
    get "reports", to: "reports#index", on: :member
  end

  resources :documents do
    get "export", to: "documents#export", on: :collection, as: "export"
  end
  resources :register_sketches
  resources :preload_registers, only: [:edit, :destroy, :update]
  resources :drivers do
    resources :savings, except: [:index] do
      put 'mark_as_paid', on: :member
    end
  end
  resources :maintenances, except: :index do
    post "multiple", to: "maintenances#create_multiple", on: :collection, as: "multiple"
  end
  get 'maintenances', to: 'maintenances#index'

  resources :registers, except: :index do
    post "multiple", to: "registers#create_multiple", on: :collection, as: "multiple"
    get "print", to: "registers#print", on: :collection, as: "print"
  end
  get 'registers', to: 'registers#index'
  get 'savings', to: 'savings#index'
  get 'savings/index2', to: 'savings#index2', as: 'savings_index2'

  post "utils/change_vehicle", to: "utils#change_current_vehicle", as: 'change_vehicle'
  put "utils/change_account", to: "utils#change_user_account", as: 'change_account'

  resources :reports, only: [:index]

  resources :global_settings, only: [:index, :update]

  resources :users, except: [:show] do
    get :account, to: "users#account", on: :collection
    put :update_account, to: "users#update_account", on: :collection
  end
end
