class QuizController < ApplicationController
  before_action :authenticate_user!

  # 問題番号順かランダムでクイズを作成する
  def create
    @category = Category.find(params[:category_id])
    # セッションのリセット
    reset_session_for_quiz
    # 問題番号順か、ランダムに並び替える
    session[:question_ids] = @category.prepare_quiz(params[:random] == 'true')
    # 最初の問題へリダイレクト
    redirect_to category_question_path(@category, session[:question_ids].first)
  end

  private

  def reset_session_for_quiz
    session[:question_ids] = nil
    session[:results] = nil
  end
end
