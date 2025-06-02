Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :categories

  resources :question_categories do

    resources :questions, only: :show do
      resources :check_answers, only: :create # 回答チェック
      resource :memo, only: [:update, :destroy] # メモ機能

      member do
        get :next # 次の問題への遷移アクション
      end
    end

    resources :csv_imports, only: :create # CSVインポート

    post 'start_quiz', to: 'quiz#create', as: :start_quiz # クイズ開始アクション
  end

  resources :results, only: [:index, :show, :destroy] do
    collection do
      get :create_quiz, to: 'results#create_quiz_results' # クイズ結果登録アクション
    end
  end

  resources :users, only: [:index, :show, :edit, :update, :destroy]
  get '/csv_upload_guidelines', to: 'home#csv_upload_guidelines'
end
