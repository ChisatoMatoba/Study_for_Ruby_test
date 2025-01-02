class MemosController < ApplicationController
  before_action :authenticate_user!

  def update
    question = Question.find(params[:question_id])
    memo_content = params[:memo_content].presence || '' # 空の場合でも''として保存
    if question.update(memo: memo_content)
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def destroy
    @question = Question.find(params[:question_id])
    if @question.update(memo: nil)
      redirect_to user_path(current_user), notice: 'メモが正常に削除されました。'
    else
      redirect_to user_path(current_user), alert: 'メモの削除に失敗しました。'
    end
  end
end
