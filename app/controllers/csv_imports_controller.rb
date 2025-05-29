class CsvImportsController < ApplicationController
  before_action :authenticate_user!
  before_action :require_admin_or_owner

  # csvファイルをインポートする
  def create
    @category = Category.find_by(id: params[:category_id])

    if params[:file].present?
      overwrite = params[:overwrite] == '1'
      begin
        Question.import(params[:file], @category, overwrite)
        redirect_to category_path(@category), notice: '正常にインポートできました'
      rescue CSV::MalformedCSVError => e
        redirect_to category_path(@category), alert: "CSVのフォーマットが不正です: #{e.message}"
      rescue StandardError => e
        redirect_to category_path(@category), alert: e.message.to_s
      end
    else
      redirect_to category_path(@category), alert: 'インポートに失敗しました'
    end
  end
end
