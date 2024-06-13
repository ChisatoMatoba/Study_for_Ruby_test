class ResultsController < ApplicationController
  before_action :authenticate_user!

  def create_quiz_results
    session_ts = Time.current.strftime('%Y%m%d%H%M%S').to_i
    @quiz_results = save_quiz_results(session[:results], session_ts)

    redirect_to results_path(session_ts: @quiz_results.first.session_ts)
  end

  def index
    @session_ts = params[:session_ts].to_i
    @quiz_results = QuizResult.where(session_ts: @session_ts)
    @category = Category.includes(:questions).find(@quiz_results.first.category_id)
    @questions = @category.questions
  end

  def show
    @session_ts = params[:session_ts].to_i
    @question = Question.find(params[:id])
    @choices = @question.choices
  end

  def destroy
    @quiz_result = QuizResult.where(session_ts: params[:session_ts])

    if @quiz_result.destroy_all
      redirect_to user_path(current_user), notice: 'クイズ結果が正常に削除されました。'
    else
      redirect_to user_path(current_user), alert: '削除するデータが見つかりませんでした。'
    end
  end

  private

  def save_quiz_results(results, session_ts)
    quiz_results = []
    results.each do |question_id, result|
      quiz_result = QuizResult.create!(
        user_id: current_user.id,
        category_id: Category.find(Question.find(question_id).category_id).id,
        question_id: question_id,
        selected: result['selected'],
        correct: result['correct'],
        is_correct: result['is_correct'],
        session_ts: session_ts
      )
      quiz_results << quiz_result
    end
    quiz_results
  end
end
