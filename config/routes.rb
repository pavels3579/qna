Rails.application.routes.draw do
  devise_for :users
  resources :questions do
    resources :answers, shallow: true, only: %i[create update destroy] do
      patch :mark_as_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy

  root to: 'questions#index'

end
