class QuestionsController < ApplicationController

  def index
    @questions = Question.all
    render json: @questions.to_json(:include => {:votes=>{:only=>:id}, :answers=>{:only=> [:id, :content]}}, :only => ["id", "title", "content", "votes", "answers"],)
  end

  def show
    @question = Question.find(params[:id])
    render json: @question
  end

end
