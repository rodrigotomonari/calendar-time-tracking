Rails.application.routes.draw do

  namespace :api do
    get 'projects/fancytree_recents', to: 'projects#fancytree_recents', defaults: { format: 'json' }
    get 'projects/:status', to: 'projects#fancytree', defaults: { format: 'json' }
    get 'tasks', to: 'tasks#index', defaults: { format: 'json' }
    post 'tasks', to: 'tasks#create'
    patch 'tasks/:id', to: 'tasks#update', as: nil
    put 'tasks/:id', to: 'tasks#update', as: nil
    delete 'tasks/:id', to: 'tasks#destroy', as: nil
  end

  resources :profiles
  resources :subprojects
  resources :projects
  resources :phases
  resources :clients

  scope 'reports' do
    get '/', to: 'reports#index', as: :reports
    get '/clients', to: 'reports#clients', as: :reports_clients
    get '/projects', to: 'reports#projects', as: :reports_projects
    get '/subprojects', to: 'reports#subprojects', as: :reports_subprojects
    get '/users', to: 'reports#users', as: :reports_users
  end

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
