class CheckAnswersController < ApplicationController
  before_action :authenticate_user!

  # 選択の正誤をチェックする
  def create
    @question = Question.find(params[:question_id])
    selected_ids = params[:choice_ids].map(&:to_i)
    result = @question.session_result(selected_ids)

    # セッションに結果を保存
    session[:results] ||= {}
    session[:results][@question.id] = result

    correct_choices = @question.choices.where(is_correct: true).pluck(:content)
    respond_to do |format|
      format.json do
        render json: {
          is_correct: result[:is_correct],
          correct_choices: correct_choices,
          explanation: @question.explanation,
          memo: @question.memo
        }
      end
    end
  end
end
