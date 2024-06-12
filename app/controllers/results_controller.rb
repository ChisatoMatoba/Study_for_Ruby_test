class ResultsController < ApplicationController
  def destroy
    @quiz_result = QuizResult.where(session_ts: params[:session_ts])

    if @quiz_result.destroy_all
      redirect_to user_path(current_user), notice: 'クイズ結果が正常に削除されました。'
    else
      redirect_to user_path(current_user), alert: '削除するデータが見つかりませんでした。'
    end
  end
end
