class QuestionCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_owner, only: %i[new create]

  def index
    @question_categories = QuestionCategory.all.includes(:questions)
  end

  def new
    @question_category = QuestionCategory.new
  end

  def create
    @question_category = QuestionCategory.new(question_category_params)
    if @question_category.save
      redirect_to @question_category, notice: '問題集が正常に作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @question_category = QuestionCategory.find(params[:id])
    @questions = @question_category.questions.includes(:choices)
  end

  def destroy
    redirect_to(root_path, alert: '権限がありません。') && return unless current_user&.owner?

    @question_category = QuestionCategory.find(params[:id])
    @question_category.destroy
    redirect_to question_categories_url, notice: '問題集が正常に削除されました。'
  end

  private

  def question_category_params
    params.require(:question_category).permit(:name)
  end
end
