Rails.application.routes.draw do
  devise_for :users

  concern :commentable do
    resources :comments
  end

  resources :questions, concerns: :commentable, shallow: true do
    resources :answers, concerns: :commentable
  end

  root to: "questions#index"
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
