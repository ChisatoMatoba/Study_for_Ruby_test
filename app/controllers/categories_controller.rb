class CategoriesController < ApplicationController
  before_action :authenticate_user!
  before_action :require_owner
  before_action :set_category, only: [:show, :edit, :update, :destroy]

  def index
    @categories = Category.all.includes(:question_categories)
  end

  def show
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
  end

  def update
    if @category.update(category_params)
      redirect_to categories_path, notice: 'カテゴリーが正常に更新されました。'
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      redirect_to categories_path, notice: 'カテゴリーが正常に削除されました。'
    else
      redirect_to categories_path, alert: 'カテゴリーを削除できませんでした。'
    end
  end

  private

  # owner権限を要求するメソッド
  def require_owner
    redirect_to root_path, alert: 'この操作にはオーナー権限が必要です。' unless current_user&.owner?
  end

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name)
  end
end
