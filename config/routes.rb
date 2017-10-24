Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions'}

  root to: 'static#index'

  resources :todos, controller: 'todo_lists', only: [:index]
end
