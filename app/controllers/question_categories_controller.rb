class QuestionCategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_owner, only: %i[new create]

  def new
    @category = Category.find(params[:category_id])
    @question_category = QuestionCategory.new
  end

  def create
    @category = Category.find(params[:category_id])
    @question_category = @category.question_categories.build(question_category_params)
    if @question_category.save
      redirect_to category_question_category_path(@category, @question_category), notice: '問題集が正常に作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @question_category = QuestionCategory.find(params[:id])
    @category = @question_category.category
    @questions = @question_category.questions.includes(:choices)
  end

  def destroy
    redirect_to(root_path, alert: '権限がありません。') && return unless current_user&.owner?

    @question_category = QuestionCategory.find(params[:id])
    @category = @question_category.category
    @question_category.destroy
    redirect_to categories_path, notice: '問題集が正常に削除されました。'
  end

  private

  def question_category_params
    params.require(:question_category).permit(:name)
  end
end
