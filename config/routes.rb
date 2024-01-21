Rails.application.routes.draw do

# 顧客用
# URL /users/sign_in ...
devise_for :users,skip: [:passwords], controllers: {
  registrations: "user/registrations",
  sessions: 'user/sessions'
}

# 管理者用
# URL /admin/sign_in ...
devise_for :admin, skip: [:registrations, :passwords] ,controllers: {
  sessions: "admin/sessions"
}

#ゲストユーザー
  devise_scope :user do
    post "user/guest_sign_in", to: "user/sessions#guest_sign_in"
  end

#検索機能
  get "search" => "searches#search"

  scope module: :user do
    root to: 'homes#top'
    resources :users,only: [:index,:show,:edit,:update,:create] do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'relationships#followings', as: 'followings'
      get 'followers' => 'relationships#followers', as: 'followers'
    end

    resources :games do
      resources :comments,only: [:create,:destroy] do
        resource :nices,only: [:create,:destroy]
      end
    end
    resources :messages, only: [:show,:create,:destroy]
    #resources :rooms   , only: [:create,:show]

  end

  namespace :admin do
    get "/" => "homes#top"
    get "search" => "searches#search"
    resources :users, only: [:index,:show,:edit,:update] do
     resources :comments, only: [:destroy]
    end

    resources :games, only: [:index,:new,:create,:show,:edit,:update]
    resources :genres,only: [:index,:create,:edit,:update]

  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
