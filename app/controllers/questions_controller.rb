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
  end

  def check_answer
    @question = Question.find(params[:question_id])
    correct_choice_ids = @question.choices.where(is_correct: true).pluck(:id)
    is_correct = (params[:choice_ids].map(&:to_i) - correct_choice_ids).empty? && (correct_choice_ids - params[:choice_ids].map(&:to_i)).empty?
    correct_choices = Choice.find(correct_choice_ids).map(&:content)
    explanation = @question.explanation
    render json: { is_correct: is_correct, correct_choices: correct_choices, explanation: explanation }
  end
end
