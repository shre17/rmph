Rails.application.routes.draw do
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }
  get 'home/index'
  root 'home#index'
  resources :change_passwords do
    member do
      patch :change_password
    end 
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
