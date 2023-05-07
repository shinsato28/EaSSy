Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }


  namespace :admin do
    get 'homes/top', as: "top"

    resources :users,only: [:index, :show, :edit, :update] do
      get "novels_index", on: :member
    end
    resources :novels,only: [:edit, :update] do
      resources :novel_comments,only: [:index, :edit, :update]
    end
  end


  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end

  scope module: :public do
    get '/' => "homes#top", as: "root"
    get 'about' => 'homes#about'

    resources :users, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      patch 'withdraw', on: :collection
      get 'unsubscribe', on: :collection
      get "novels_index", on: :member
    end

    resources :novels,only: [:index, :show, :new, :create, :edit, :update] do
      post :confirm, on: :collection
      resource :favorites, only: [:create, :destroy]
      resources :novel_comments,only: [:index, :create, :edit, :update, :destroy]
    end
  end
end
