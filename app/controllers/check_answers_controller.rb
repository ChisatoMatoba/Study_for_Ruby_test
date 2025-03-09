class CheckAnswersController < ApplicationController
  before_action :authenticate_user!

  # POST /categories/:category_id/questions/:question_id/check_answers
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
          memo: @question.memo_content(current_user)
        }
      end
    end
  end
end
