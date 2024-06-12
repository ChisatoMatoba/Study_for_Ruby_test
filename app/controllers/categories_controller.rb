class CategoriesController < ApplicationController
  before_action :authenticate_user!

  def index
    @categories = Category.all.includes(:questions)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)
    if @category.save
      redirect_to @category, notice: 'カテゴリが正常に作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @category = Category.find(params[:id])
    @questions = @category.questions.includes(:choices)
  end

  def destroy
    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_url, notice: 'カテゴリが正常に削除されました。'
  end

  def start_quiz
    @category = Category.find(params[:id])

    # セッションのリセット
    session[:question_ids] = nil
    session[:results] = nil

    session[:question_ids] = @category.questions.pluck(:id)

    # ランダムに並び替える
    session[:question_ids].shuffle! if params[:random] == 'true'
    redirect_to category_question_path(@category, session[:question_ids].first) # 最初の問題へリダイレクト
  end

  def results
    @category = Category.find(params[:id])
    @questions = @category.questions

    session_ts = Time.current.strftime('%Y%m%d%H%M%S').to_i
    @quiz_results = []
    session[:results].each do |question_id, result|
      quiz_result = QuizResult.create!(
        user_id: current_user.id,
        category_id: @category.id,
        question_id: question_id,
        selected: result['selected'],
        correct: result['correct'],
        is_correct: result['is_correct'],
        session_ts: session_ts
      )
      @quiz_results << quiz_result
    end
  end

  def results_by_session
    @session_ts = params[:session_ts].to_i
    @quiz_results = QuizResult.where(session_ts: @session_ts)
    @category = Category.includes(:questions).find(@quiz_results.first.category_id)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
