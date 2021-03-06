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

  resources :wallet_transactions
  get '/levels/new' => "wallet_transactions#upgrade_level"
  get 'user/my_direct' => "home#direct_team"
  get '/dashboard' => "home#profit_details"
  post '/create_level_transactions' => "wallet_transactions#create_level_transactions"
  get 'dashboard' => 'admin#dashboard'
  get 'user/referral' => 'admin#referral'
  get 'user/my_direct' => 'admin#direct_team'
  get 'user/wallet' => 'admin#wallet_transfer'
  get 'user/upgrade' => 'admin#upgrade'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
