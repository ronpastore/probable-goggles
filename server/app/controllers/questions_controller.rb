class QuestionsController < ApplicationController
  def index
    @questions = Question.all
    render json: @questions
  end

  def create

    request_data = JSON.parse(request.body.read)
    @question = Question.new(question_params.merge(request_data))
  
    if @question.save
      render json: @question, status: :created
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  
  end
  

  private

  def question_params
    params.require(:question).permit(:question, :context, :answer, :ask_count, :audio_src_url)
  end

end
