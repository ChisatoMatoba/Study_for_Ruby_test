class CsvImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_owner

  # csvファイルをインポートする
  def create
    @question_category = QuestionCategory.find_by(id: params[:question_category_id])

    if params[:file].present?
      overwrite = params[:overwrite] == '1'
      begin
        Question.import(params[:file], @question_category, overwrite)
        redirect_to question_category_path(@question_category), notice: '正常にインポートできました'
      rescue CSV::MalformedCSVError => e
        redirect_to question_category_path(@question_category), alert: "CSVのフォーマットが不正です: #{e.message}"
      rescue StandardError => e
        redirect_to question_category_path(@question_category), alert: e.message.to_s
      end
    else
      redirect_to question_category_path(@question_category), alert: 'インポートに失敗しました'
    end
  end
end
