Rails.application.routes.draw do
  devise_for :users
  root to: 'home#index'

  resources :categories do
    member do
      get :start_quiz # クイズ開始アクション
    end

    resources :questions do
      resources :choices

      member { get :next_question } # 次の問題を表示するアクション
      collection { post :import } # CSVインポートアクション
    end
  end
end
