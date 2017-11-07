Rails.application.routes.draw do
  devise_for :users, controllers: {omniauth_callbacks: 'users/omniauth_callbacks', sessions: 'users/sessions'}

  root to: 'static#index'

  get :dashboard, to: 'dashboard#index'

  resource :user, only: [:edit, :update]

  resources :todo_lists, path: 'todos' do
    collection do
      get :archived
      get :plan
    end

    member do
      put :sort, constraints: {format: :json}
      put :archive
      put :restore
    end
  end
end
