Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :categories do
    member do
      get :start_quiz # クイズ開始アクション
      get :results # 結果表示アクション
    end

    collection do
      get 'results_by_session/:session_ts', to: 'categories#results_by_session', as: 'results_by_session'
    end

    resources :questions do
      member do
        post :check_answer # 回答チェックアクション
        get :next # 次の問題への遷移アクション
      end
      collection { post :import } # CSVインポートアクション
    end
  end

  resources :users, only: :show do
    resources :results, only: :destroy
  end

  get '/csv_upload_guidelines', to: 'home#csv_upload_guidelines'
end
