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

    # 正答率
    correct_answers_count = @quiz_results.where(is_correct: true).count
    total_questions_count = @quiz_results.count
    @accuracy_rate = (correct_answers_count.to_f / total_questions_count * 100).round(2)
  end

  def show
    @session_ts = params[:session_ts].to_i
    @question = Question.find(params[:id])
    @choices = @question.choices
  end

  def destroy
    @quiz_result = QuizResult.where(session_ts: params[:session_ts])
    require_self_or_owner(@quiz_result.user_id)

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
        selected: result[:selected],
        correct: result[:correct],
        is_correct: result[:is_correct],
        session_ts: session_ts
      )
      quiz_results << quiz_result
    end
    quiz_results
  end

  def require_self_or_owner(user_id)
    # Ownerはすべてのユーザーの情報にアクセス可能
    return if current_user.owner?

    # Owner以外は、自分の情報にしかアクセスできない
    redirect_to root_path unless current_user.id == user_id.to_i
  end
end
