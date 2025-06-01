class QuizController < ApplicationController
  before_action :authenticate_user!

  # 問題番号順かランダムでクイズを作成する
  def create
    @question_category = QuestionCategory.find(params[:question_category_id])
    # セッションのリセット
    reset_session_for_quiz
    # 問題番号順か、ランダムに並び替える
    session[:question_ids] = @question_category.prepare_quiz(params[:random] == 'true')
    # 最初の問題へリダイレクト
    redirect_to question_category_question_path(@question_category, session[:question_ids].first)
  end

  private

  def reset_session_for_quiz
    session[:question_ids] = nil
    session[:results] = nil
  end
end
