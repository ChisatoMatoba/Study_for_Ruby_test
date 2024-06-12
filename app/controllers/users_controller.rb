class UsersController < ApplicationController
  def show
    @user = User.find(params[:id])
    @quiz_results = QuizResult.aggregate_results_by_session
  end
end
