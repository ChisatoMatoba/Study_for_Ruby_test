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

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
