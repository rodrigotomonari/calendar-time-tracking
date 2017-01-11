Rails.application.routes.draw do

  namespace :api do
    get 'tasks', to: 'tasks#index', defaults: { format: 'json' }
    post 'tasks', to: 'tasks#create'
    patch 'tasks/:id', to: 'tasks#update', as: nil
    put 'tasks/:id', to: 'tasks#update', as: nil
    delete 'tasks/:id', to: 'tasks#destroy', as: nil
  end

  resources :subprojects
  resources :projects
  resources :phases
  resources :clients

  devise_for :users, skip: [:registrations], controllers: {
    sessions:  'users/sessions',
    passwords: 'users/passwords'
  }

  devise_scope :user do
    get '/login' => 'users/sessions#new', :as => 'login'
    get '/logout' => 'users/sessions#destroy', :as => 'logout'
    get 'users/edit' => 'users/registrations#edit', :as => 'edit_user_registration'
    put 'users' => 'users/registrations#update', :as => 'user_registration'
  end

  root to: 'home#index'
end
