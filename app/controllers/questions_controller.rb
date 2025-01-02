class QuestionsController < ApplicationController
  before_action :authenticate_user!

  def show
    @question = Question.find(params[:id])
    @choices = @question.choices

    # 現在の問題が全体の中で何問目かを計算
    question_ids = session[:question_ids]
    @current_question_number = question_ids.index(@question.id) + 1
    @total_questions = question_ids.count
  end

  def edit_memo_content
    question = Question.find(params[:question_id])
    memo_content = params[:memo_content].presence || '' # 空の場合でも''として保存
    if question.update(memo: memo_content)
      render json: { success: true }
    else
      render json: { success: false }
    end
  end

  def delete_memo
    @question = Question.find(params[:id])
    if @question.update(memo: nil)
      redirect_to user_path(current_user), notice: 'メモが正常に削除されました。'
    else
      redirect_to user_path(current_user), alert: 'メモの削除に失敗しました。'
    end
  end

  def next
    @question = Question.find(params[:id])
    question_ids = session[:question_ids]

    current_index = question_ids.index(@question.id)
    next_question_id = question_ids[current_index + 1] if current_index

    if next_question_id
      redirect_to category_question_path(@question.category, next_question_id)
    else
      redirect_to create_quiz_results_path
    end
  end
end
