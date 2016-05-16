class QuestionsController < ApplicationController

  def index
    @questions = Question.all
    render json: @questions.to_json(:only => ["title", "content"])
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

end
