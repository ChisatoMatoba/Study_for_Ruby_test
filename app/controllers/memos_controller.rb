class MemosController < ApplicationController
  before_action :authenticate_user!

  def update
    question = Question.find(params[:question_id])
    memo_content = params[:memo_content].presence || '' # 空の場合でも''として保存
    memo = question.memos.find_or_initialize_by(user: current_user)
    if memo.update(content: memo_content)
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def destroy
    @question = Question.find(params[:question_id])
    memo = @question.memos.find_by(user: current_user)
    if memo&.destroy
      redirect_to user_path(current_user), notice: 'メモが正常に削除されました。'
    else
      redirect_to user_path(current_user), alert: 'メモの削除に失敗しました。'
    end
  end
end
