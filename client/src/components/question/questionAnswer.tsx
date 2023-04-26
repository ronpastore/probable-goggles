import React, { useState, ChangeEvent, useEffect } from 'react';

const QUESTIONS_ENDPOINT =`${process.env.REACT_APP_API_HOST}/questions`

interface Props {
  question: string;
}

interface Response {
  answer: string;
}

const QuestionAnswer: React.FC<Props> = ({ question }) => {
  
  const [answer, setAnswer] = useState('');
  const [questionText, setQuestionText] = useState(question);
  const [loading, setLoading] = useState(false)
  
  useEffect(() => {
    // Wake up the Heroku dyno
    const response = fetch(`${QUESTIONS_ENDPOINT}`, {
      method: 'GET',
      headers: { 'Content-Type': 'application/json'}
    });
  }, []);

  const handleSubmit = async (event: React.FormEvent<HTMLFormElement>) => {
    event.preventDefault();
    setLoading(true)
    
    const response = await fetch(`${QUESTIONS_ENDPOINT}`, {
      method: 'POST',
      headers: { 'Content-Type': 'application/json'},
      body: JSON.stringify( {"question" : { "question": questionText} }),
    });

    const question: Response = await response.json();
    setLoading(false)
    setAnswer(question.answer);
  };

  const handleInputChange = (event: ChangeEvent<HTMLInputElement>) => {
    setQuestionText(event.target.value);
  };

  const buttonText = () =>  {
    return loading ? "..." : "Submit"
  }

  const buttonClasses = () => {
    return loading? "submit disabled" : "submit"
  }

  return (
    <div>
      <form onSubmit={handleSubmit}>
        
        <input 
          onChange={handleInputChange} 
          type="text" 
          value={questionText} 
          />
        
        <button type="submit" className={buttonClasses()} disabled={loading}>
          { buttonText() }
          { loading && <i className="fa fa-refresh fa-spin"></i> }  
        </button>
        
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