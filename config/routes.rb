Rails.application.routes.draw do
  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }


  namespace :admin do
    get 'homes/top', as: "top"

    resources :users,only: [:index, :show, :edit, :update]
    resources :novels,only: [:index, :edit, :update] do
      resources :novel_comments,only: [:edit, :update]
    end
  end


  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  scope module: :public do
    get '/' => "homes#top", as: "root"
    get 'about' => 'homes#about'

    resources :users, only: [:show, :edit, :update] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
      patch 'withdraw', on: :collection
      get 'unsubscribe', on: :collection
    end

    resources :novels,only: [:index, :show, :new, :create, :edit, :update] do
      resource :favorites, only: [:create, :destroy]
      resources :novel_comments,only: [:create, :edit, :update, :destroy]
    end
    get "novels/confirm" => "novels#confirm"
  end
end
