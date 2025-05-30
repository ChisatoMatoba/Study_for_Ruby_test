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

  def next
    @question = Question.find(params[:id])
    question_ids = session[:question_ids]

    current_index = question_ids.index(@question.id)
    next_question_id = question_ids[current_index + 1] if current_index

    if next_question_id
      redirect_to question_category_question_path(@question.question_category, next_question_id)
    else
      redirect_to create_quiz_results_path
    end
  end
end
