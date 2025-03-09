class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :require_self_or_owner, only: %i[show edit update destroy]

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

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'ユーザー情報を更新しました。'
    else
      flash.now[:alert] = '更新に失敗しました。'
      render :edit
    end
  end

  def destroy
    user = User.find(params[:id])
    if user.destroy
      redirect_to users_path, notice: "#{user.name} を削除しました。"
    else
      redirect_to users_path, alert: 'ユーザーの削除に失敗しました。'
    end
  end

  private

  def require_self_or_owner
    # Ownerはすべてのユーザーの情報にアクセス可能
    return if current_user.owner?

    # Owner以外は、自分の情報にしかアクセスできない
    redirect_to root_path unless current_user.id == params[:id].to_i
  end

  def user_params
    params.require(:user).permit(:name, :email, :role)
  end
end
