class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_owner, only: [:show]

  def index
    redirect_to root_path unless current_user&.owner?

    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    # セッションタイムスタンプで結果を集計する
    @quiz_results = QuizResult.aggregate_results_by_session(@user.id)

    # ユーザーが保存したすべてのメモを取得
    @questions_with_memos = Question.includes(:memos).where(memos: { user_id: @user.id }).order(:category_id, :number)
  end

  private

  def require_owner
    # Ownerはすべてのユーザーの情報にアクセス可能
    return if current_user.owner?

    # Owner以外は、自分の情報にしかアクセスできない
    redirect_to root_path unless current_user.id == params[:id].to_i
  end
end
