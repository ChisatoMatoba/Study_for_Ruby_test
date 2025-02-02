class CsvImportsController < ApplicationController
  before_action :authenticate_user!

  # csvファイルをインポートする
  def create
    @category = Category.find_by(id: params[:category_id])

    if params[:file].present?
      overwrite = params[:overwrite] == '1'
      begin
        result = Question.import(params[:file], @category, overwrite)

        if result[:errors].empty?
          redirect_to category_path(@category), notice: "#{result[:success_count]}件の問題を正常にインポートしました"
        else
          error_message = "#{result[:success_count]}件の問題をインポートしましたが、以下の行でエラーが発生しました:\n" + result[:errors].join("\n")
          redirect_to category_path(@category), alert: error_message
        end
      rescue CSV::MalformedCSVError => e
        redirect_to category_path(@category), alert: "CSVのフォーマットが不正です: #{e.message}"
      rescue StandardError => e
        redirect_to category_path(@category), alert: "エラーが発生しました: #{e.message}"
      end
    else
      redirect_to category_path(@category), alert: 'インポートに失敗しました'
    end
  end
end
