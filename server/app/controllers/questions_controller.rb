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
    prompt = get_prompt(content[:text])
    
    answer = get_answer(prompt)
    
    puts answer

    # if @question.save
    #   render json: @question, status: :created
    # else
    #   render json: @question.errors, status: :unprocessable_entity
    # end

    render json: @question
  end


  
  private

  def get_answer(prompt)
    client = OpenAI::Client.new(access_token: ENV['OPENAI_ACCESS_KEY'])
    response = client.completions(
      parameters: {
        model: "text-davinci-003",
        prompt: prompt,
        # temperature: 0.2,
        max_tokens: 500,
      }
    )

    response['choices'][0]['text'].lstrip
  end

  def get_prompt(page_text)
    prompt = 
      "You are an AI assistant speaking from the perspective of an author. You are tasked with answering questions about your book, 'Fix Practice' in a simple and helpful way.

      The book is about a method for practicing music, and aims to provide a simple method for continued growth, originality and memory, using 3 simple rules. 
      An exerpt from the book will supplied under the [Page] section.  Use that as much as you can to answer the question, which will be supplied under the 
      [Question] section. 

      A brief outline of rules of the practice method will be under the [Rules] section.

      [Rules]
      A block is a set of any 5 musical exercises you want. The goal of the method is to create 5 blocks. 
      A block becomes locked when it's exercises have been played 5 times the total number of blocks, once a block is locked you can't practice it's exercises until a new block is created.
      Once all blocks are locked, you must create a new block. 

      [Page]
      #{page_text}

      [Question]
      #{@question.question}"
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
