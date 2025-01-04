class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # セッションタイムスタンプで結果を集計する
    @quiz_results = QuizResult.aggregate_results_by_session

    # 現在のユーザーが保存したすべてのメモを取得
    @questions_with_memos = Question.includes(:memos).where(memos: { user_id: current_user.id }).order(:category_id, :number)
  end
end
