import React, { useState, ChangeEvent } from 'react';

interface Props {
  question: string;
}

interface Response {
  answer: string;
}

const API_URL = 'http://localhost:3000/questions';

const QuestionAnswer: React.FC<Props> = ({ question }) => {
  
  const [answer, setAnswer] = useState<string>('');
  const [questionText, setQuestionText] = useState<string>(question);

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();

    const response = await fetch(`${API_URL}`, {
      method: 'POST',
      headers: {
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        "question" : { "question": questionText} 
      }),
    });
    const data: Response = await response.json();
    setAnswer(data.answer);
  };

  const handleInputChange = (event: ChangeEvent<HTMLInputElement>) => {
    setQuestionText(event.target.value);
  };

  return (
    <div>
      <form onSubmit={handleSubmit}>
        <input 
          onChange={handleInputChange} 
          type="text" 
          value={questionText} 
          />
        <button type="submit">Submit</button>
      </form>

      {answer && (
        <div>
          <p className="notice">{answer}</p>
        </div>
      )}
    </div>
  );
};

export default QuestionAnswer;