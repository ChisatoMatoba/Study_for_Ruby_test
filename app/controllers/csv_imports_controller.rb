class CsvImportsController < ApplicationController
  before_action :authenticate_user!

  # csvファイルをインポートする
  def create
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
end
