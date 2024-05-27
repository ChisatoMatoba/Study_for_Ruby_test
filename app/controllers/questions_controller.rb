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

  def answer
    @question = Question.find(params[:id])
    selected_choices = params[:choices] || []
    correct_choices = question.choices.where(is_correct: true).pluck(:id).map(&:to_s)
    is_correct = (selected_choices.sort == correct_choices.sort)

    current_user.quiz_results.create!(
      category: @question.category,
      question: @question,
      correct: is_correct,
      answer_detail: selected_choices.join(',')
    )

    # 次の質問へのリダイレクトや結果表示の処理を
  end
end
