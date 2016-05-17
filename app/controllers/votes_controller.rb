class VotesController < ApplicationController

  def create
    if params["question_id"]
      Question.find(params["question_id"]).votes.create
    end
    redirect_to 'http://localhost:8000/app/views/questions/Questions.elm'
  end

end
