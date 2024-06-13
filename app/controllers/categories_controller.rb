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
    reset_session_for_quiz
    # 問題番号順か、ランダムに並び替える
    session[:question_ids] = @category.prepare_quiz(params[:random] == 'true')
    # 最初の問題へリダイレクト
    redirect_to category_question_path(@category, session[:question_ids].first)
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end

  def reset_session_for_quiz
    session[:question_ids] = nil
    session[:results] = nil
  end
end
