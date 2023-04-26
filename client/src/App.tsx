import React from 'react';
import logo from './logo.svg';
import './App.css';
import QuestionAnswer from './components/question/questionAnswer';

function App() {
  return (
    <div className="App">    
      <iframe sandbox="allow-scripts allow-same-origin allow-popups" width="300" frameBorder="0" height="300" src="https://read.amazon.com/kp/card?asin=B07H6Z1GR8&preview=inline&linkCode=kpe&ref_=cm_sw_r_kb_dp_F5RGHQ7YX2JATHB1PYQX" ></iframe>
      <h1>Ask a question about the book...</h1>
      <p>Inspired by the AI experiment, <a href="https://www.Askmybook.com">AskMyBook.com</a></p>
      <QuestionAnswer question="Who is this book for?" />
    </div>
  );
}

export default App;
