class CreateQuestions < ActiveRecord::Migration[7.0]
  def change
    create_table :questions do |t|
      t.string :question, limit: 140
      t.text :context
      t.text :answer, limit: 1000
      t.integer :ask_count, default: 1
      t.string :audio_src_url, limit: 255
      t.timestamps
    end
  end
end
