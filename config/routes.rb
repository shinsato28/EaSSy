Rails.application.routes.draw do

  namespace :admin do
    get 'users/index'
    get 'users/show'
    get 'users/edit'
    get 'users/update'
  end
  namespace :admin do
    get 'homes/top', as: "top"
  end

  devise_for :users,skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  scope module: :public do
    get '/' => "homes#top", as: "root"
    get 'about' => 'homes#about'

    resources :users, only: [:show, :edit, :update] do
      patch 'withdraw', on: :collection
      get 'unsubscribe', on: :collection
    end
  end

  devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
    sessions: "admin/sessions"
  }

end
