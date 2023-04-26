desc "Generate emebeddings against openai API"
task :generate_embeddings do
    
    access_key = ENV['OPENAI_ACCESS_KEY']
    client = OpenAI::Client.new(access_token: access_key)
    
    embeddings = []

    # Load PDF
    reader = PDF::Reader.new('./content/fix_practice.pdf')
    reader.pages.each_with_index do |page, idx|

        page_num = idx + 1
        
        # for testing
        # break if idx > 1

        text = page.text

        response = client.embeddings(
            parameters: {
                model: "text-embedding-ada-002",
                input: text
            }
        )
        
        embedding = response['data'][0]['embedding']

        puts "Adding page #{page_num}.."
        embeddings << {page: page_num, embedding: embedding, text: text}
    end

    CSV.open("./content/embeddings.csv", "w") do |csv|
        csv << [:page, :embedding, :text]
        embeddings.each do |embedding|
            csv << [embedding[:page], embedding[:embedding], embedding[:text]]
        end
    end
    
end
