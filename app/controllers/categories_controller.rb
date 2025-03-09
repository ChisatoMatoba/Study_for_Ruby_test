class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_owner, only: %i[new create]

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
    redirect_to root_path, alert: '権限がありません。' unless current_user&.owner?

    @category = Category.find(params[:id])
    @category.destroy
    redirect_to categories_url, notice: 'カテゴリが正常に削除されました。'
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
