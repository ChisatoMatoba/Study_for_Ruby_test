class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_owner, except: [:index]

  def index
    @categories = Category.all.includes(:question_categories)
  end

  def new
    @category = Category.new
  end

  def create
    @category = Category.new(category_params)

    if @category.save
      redirect_to categories_path, notice: 'カテゴリが正常に作成されました。'
    else
      render :new
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.question_categories.exists?
      redirect_to categories_path, alert: '関連する問題集があるため、このカテゴリは削除できません'
    elsif @category.destroy
      redirect_to categories_path, notice: 'カテゴリが正常に削除されました。'
    else
      redirect_to categories_path, alert: @category.errors.full_messages.join(', ')
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
