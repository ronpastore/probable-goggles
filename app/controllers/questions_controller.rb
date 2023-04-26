require 'openai_concern'

class QuestionsController < ApplicationController

  include OpenAiConcern
  
  skip_before_action :verify_authenticity_token

  def index
    @questions = Question.all
    render json: @questions
  end

  def create
    @question = Question.new(question_params)
    @question.question.downcase!
    @question.question.strip!
 
    # check cached Qs here
    previous_question = Question.find_by(question: @question.question)
    if previous_question
      logger.info "Cached question found, using.."
      previous_question.ask_count += 1
      previous_question.save!
      render json: previous_question
      return
    end

    page = most_similar_page
    prompt = get_prompt(page[:text])
    answer = get_answer(prompt)
    
    @question.answer = answer
    @question.context = prompt
    @question.ask_count = 1 
    
    if @question.save
      render json: @question, status: :created
    else
      render json: @question.errors, status: :unprocessable_entity
    end
  end


  private


  def question_params
    params.require(:question).permit(:question)
  end

end
