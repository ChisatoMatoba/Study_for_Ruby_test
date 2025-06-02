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
      redirect_to categories_path, notice: 'カテゴリーが正常に作成されました。'
    else
      render :new
    end
  end

  def edit
    @category = Category.find(params[:id])
  end

  def update
    @category = Category.find(params[:id])
    if @category.update(category_params)
      redirect_to categories_path, notice: 'カテゴリーが正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    @category = Category.find(params[:id])
    if @category.destroy
      redirect_to categories_path, notice: 'カテゴリーが正常に削除されました。'
    else
      redirect_to categories_path, alert: 'カテゴリーを削除できませんでした。'
    end
  end

  private

  def category_params
    params.require(:category).permit(:name)
  end
end
