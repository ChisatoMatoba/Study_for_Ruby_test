Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :categories do
    post 'start_quiz', to: 'quiz#create', as: :start_quiz # クイズ開始アクション

    resources :questions, only: :show do
      member do
        post :check_answer # 回答チェックアクション
        post :edit_memo_content # メモ編集アクション
        get :next # 次の問題への遷移アクション
        delete :delete_memo, to: 'questions#delete_memo', as: :delete_memo # メモ削除アクション
      end
      collection { post :import } # CSVインポートアクション
    end
  end

  resources :results, only: %i(index show destroy) do
    collection do
      get :create_quiz, to: 'results#create_quiz_results' # クイズ結果登録アクション
    end
  end

  resources :users, only: :show
  get '/csv_upload_guidelines', to: 'home#csv_upload_guidelines'
end
