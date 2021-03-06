Rails.application.routes.draw do
  devise_for :users

  # корень сайта
  root "events#index"

  resources :events do
    resources :comments, only: [:create, :destroy]
    resources :subscriptions, only: [:create, :destroy]
    # Вложенные в ресурс события ресурсы фотографий
    resources :photos, only: [:create, :destroy]

    post :show, on: :member
  end
  # Не все действия поддерживаются – только show, edit, update
  resources :users, only: [:show, :edit, :update]
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
