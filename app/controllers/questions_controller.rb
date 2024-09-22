class QuestionsController < ApplicationController
  before_action :authenticate_user!

  def import
    @category = Category.find_by(id: params[:category_id])
    if params[:file].present?
      overwrite = params[:overwrite] == '1'
      begin
        Question.import(params[:file], @category, overwrite)
        redirect_to category_path(@category), notice: '正常にインポートできました'
      rescue StandardError => e
        redirect_to category_path(@category), alert: e.message
      end
    else
      redirect_to category_path(@category), alert: 'インポートに失敗しました'
    end
  end

  def show
    @question = Question.find(params[:id])
    @choices = @question.choices

    # 現在の問題が全体の中で何問目かを計算
    question_ids = session[:question_ids]
    @current_question_number = question_ids.index(@question.id) + 1
    @total_questions = question_ids.count
  end

  def check_answer
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
          explanation: @question.explanation
        }
      end
    end
  end

  def edit_memo_content
    question = Question.find(params[:question_id])
    memo_content = params[:learned_content]
    if question.update(memo: memo_content)
      render json: { success: true }
    else
      render json: { success: false }
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
