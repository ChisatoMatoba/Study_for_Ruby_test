class QuestionsController < ApplicationController
  before_action :authenticate_user!

  def import
    @category = Category.find_by(id: params[:category_id])
    if params[:file].present?
      overwrite = params[:overwrite] == '1'
      begin
        Question.import(params[:file], @category, overwrite)
        redirect_to category_questions_path(@category), notice: '正常にインポートできました'
      rescue StandardError => e
        redirect_to category_questions_path(@category), alert: e.message
      end
    else
      redirect_to category_questions_path(@category), alert: 'インポートに失敗しました'
    end
  end

  def show
    @question = Question.find(params[:id])
    @choices = @question.choices
    @show_solution = params[:show_solution] == 'true'
  end

  def check_answer
    @question = Question.find(params[:question_id])
    selected_ids = params[:choice_ids].map(&:to_i)
    correct_choice_ids = @question.choices.where(is_correct: true).pluck(:id)

    is_correct = (params[:choice_ids].map(&:to_i) - correct_choice_ids).empty? && (correct_choice_ids - params[:choice_ids].map(&:to_i)).empty?
    correct_choices = Choice.find(correct_choice_ids).map(&:content)

    # セッションに結果を保存
    session[:results] ||= {}
    session[:results][@question.id] = {
      selected: selected_ids,
      correct: correct_choice_ids,
      is_correct: is_correct
    }

    respond_to do |format|
      format.json { render json: { is_correct: is_correct, correct_choices: correct_choices, explanation: @question.explanation } }
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
      redirect_to results_category_path(@question.category)
    end
  end
end
