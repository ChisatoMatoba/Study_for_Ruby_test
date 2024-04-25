class ChoicesController < ApplicationController
  def new
    @choice = Choice.new
  end

  def create
    @choice = Choice.new(choice_params)
    if @choice.save
      redirect_to @choice, notice: '選択肢が正常に作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
  @choice = Choice.find(params[:id])
  end

  def edit
    @choice = Choice.find(params[:id])
  end

  def update
    @choice = Choice.find(params[:id])
    if @choice.update(choice_params)
      redirect_to @choice, notice: '選択肢が正常に更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @choice = Choice.find(params[:id])
    @choice.destroy
    redirect_to choices_url, notice: '選択肢が正常に削除されました。'
  end

  private

  def choice_params
    params.require(:choice).permit(:question_id, :content)
  end
end
