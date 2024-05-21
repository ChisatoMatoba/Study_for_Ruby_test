class QuestionsController < ApplicationController
  def import
    @category = Category.find(params[:category_id])
    if params[:file].present?
      Question.import(params[:file], @category)
      redirect_to category_questions_path(@category), notice: '正常にインポートできました'
    else
      redirect_to new_category_question_path(@category), alert: 'インポートに失敗しました'
    end
  end
end
