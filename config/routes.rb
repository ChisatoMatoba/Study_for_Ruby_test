Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :categories do
    resources :questions do
      resources :choices
    end
  end
end
