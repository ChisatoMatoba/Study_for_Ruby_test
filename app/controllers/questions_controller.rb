class QuestionsController < ApplicationController
  def new
    @question = Question.new
  end

  def create
    @question = Question.new(question_params)
    if @question.save
      redirect_to @question , notice: '質問が正常に作成されました。'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @question = Question.find(params[:id])
  end

  def edit
    @question = Question.find(params[:id])
  end

  def update
    @question = Question.find(params[:id])
    if @question.update(question_params)
      redirect_to @question, notice: '選択肢が正常に更新されました。'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to questions_url, notice: '質問が正常に削除されました。'
  end

  private

  def question_params
    params.require(:question).permit(:category_id, :content).merge(category_id: params[:category_id])
  end
end
