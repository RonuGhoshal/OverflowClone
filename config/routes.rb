Rails.application.routes.draw do
  scope '/api' do
    resources :answers
    resources :questions
    resources :comments
    resources :users
    resources :votes
  end
end
