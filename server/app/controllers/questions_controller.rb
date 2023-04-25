class QuestionsController < ApplicationController

  require 'cosine_similarity'

  skip_before_action :verify_authenticity_token

  def index
    @questions = Question.all
    render json: @questions
    puts(get_embeddings[0][:embedding])
    # render json: get_embeddings
  end

  def create
    request_data = JSON.parse(request.body.read)
    @question = Question.new(question_params.merge(request_data))

    
    content = most_similar_page
    puts content
    # if @question.save
    #   render json: @question, status: :created
    # else
    #   render json: @question.errors, status: :unprocessable_entity
    # end

    render json: @question
  end


  
  private

  def get_prompt
    prompt = 
      "You are an AI assistant. You are tasked with answer questions about a book that a users answer.

      You will be provided company information from Sterline Parts under the [Article] section. The customer question
      will be provided unders the [Question] section. You will answer the customers questions based on the article.
      If the users question is not answered by the article you will respond with 'I'm sorry I don't know.'

      [Article]
      #{original_text}

      [Question]
      #{question}"
  end

  def most_similar_page
    
    puts "getting similarity..."
    similarity = []
    question_embedding = get_question_embedding
    content_embeddings = get_embeddings
    content_embeddings.each do |page|
      similarity << cosine_similarity(question_embedding, page[:embedding])
    end

    index_of_max = similarity.index(similarity.max)
    puts index_of_max
    return content_embeddings[index_of_max]

  end

  def get_question_embedding

    puts "getting question embedding..."
    access_key = ENV['OPENAI_ACCESS_KEY']
    client = OpenAI::Client.new(access_token: access_key)

    # TODO ENV to get model
    response = client.embeddings(
        parameters: {
            model: "text-embedding-ada-002",
            input: @question.question
        }
    )
    
    puts "got it..."
    return response['data'][0]['embedding']
  end
  
  
  def get_embeddings
    embeddings = []
    CSV.foreach("../content/embeddings.csv", headers: true) do |row|
        embeddings << {
            embedding: JSON.parse(row['embedding']), 
            text: row['text'], 
            page: row['page'] 
        }
        
    end
    embeddings
  end

  def question_params
    params.require(:question).permit(:question)
  end

end
