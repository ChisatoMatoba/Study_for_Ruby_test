class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    # セッションタイムスタンプで結果を集計する
    @quiz_results = QuizResult.aggregate_results_by_session
  end
end
