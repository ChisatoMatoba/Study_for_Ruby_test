class QuestionsController < ApplicationController
  def import
    @category = Category.find_by(id: params[:category_id])
    if params[:file].present?
      overwrite = params[:overwrite] == '1'
      Question.import(params[:file], @category, overwrite)
      redirect_to category_questions_path(@category), notice: '正常にインポートできました'
    else
      redirect_to new_category_question_path(@category), alert: 'インポートに失敗しました'
    end
  end
end
