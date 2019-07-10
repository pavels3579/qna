Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      patch :vote_up
      patch :vote_down
    end
  end

  resources :questions, concerns: :votable do
    resources :answers, shallow: true, only: %i[create update destroy], concerns: :votable do
      patch :mark_as_best, on: :member
    end
  end

  resources :attachments, only: :destroy
  resources :links, only: :destroy
  resources :best_answer_awards, only: :index

  root to: 'questions#index'

end
