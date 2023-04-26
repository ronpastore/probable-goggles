import React, { useState, ChangeEvent, useEffect } from 'react';

interface Props {
  question: string;
}

interface Response {
  answer: string;
}


/*
  TMP, these values should come from build system runtime via ENV.
*/
let API_URL: string 
if (window.location.hostname === "localhost") {
  API_URL = "http://localhost:3000/questions"
} else {
  API_URL = "https://nameless-eyrie-29012.herokuapp.com/questions"
}

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