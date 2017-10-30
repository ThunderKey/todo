Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions'}

  root to: 'static#index'

  resources :todo_lists, path: 'todos', only: [:index, :new, :create, :edit, :update] do
    member do
      put :sort, constraints: {format: :json}
    end
  end
end
