Rails.application.routes.draw do

  root :to => 'questions#index'

  get '/api/questions/:question_id/votes' => 'votes#create'

  scope '/api' do
    resources :answers do
      resources :votes, :defaults => { :voteable => 'answer' }
    end
    resources :questions do
      resources :votes, :defaults => { :voteable => 'question' }
    end
    resources :comments do
      resources :votes, :defaults => { :voteable => 'comment' }
    end
    resources :users
    resources :votes
  end

end
