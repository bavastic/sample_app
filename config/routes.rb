# frozen_string_literal: true

Rails.application.routes.draw do
  resources :apidocs, only: [:index]

  resources :pages, only: [:index]

  scope '/api' do
    resources :products do
      collection do
        get :options
        get :count
      end
    end

    resources :categories do
      collection do
        get :options
        get :count
        post :upload
      end
    end
  end

  root to: 'pages#index'
end
