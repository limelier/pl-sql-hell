import React from 'react';
import ReactDOM from 'react-dom';
import axios from 'axios';
import './index.css';

const apiURL = 'http://localhost:3210'

class RegisterForm extends React.Component {
    constructor(props) {
        super(props);
        this.handleChange = this.handleChange.bind(this);
    }

    handleChange(event) {
        this.props.handleChange(event.target.value);
    }

    render() {
        const email = this.props.email;
        return (
            <form onSubmit={this.props.handleSubmit}>
                <label>
                    <input
                        type="email"
                        required
                        value={email}
                        onChange={this.handleChange}
                        placeholder="someone@domain.com"
                    />
                </label>
                <input type="submit" value="Register"/>
            </form>
        );
    }
}

class Question extends React.Component {
    constructor(props) {
        super(props);
        this.handleCheckboxChange = this.handleCheckboxChange.bind(this);
    }

    handleCheckboxChange(event) {
        this.props.handleCheckboxChange(event.target.value);
    }

    render() {
        let {q_text, answers} = this.props.question;
        if (!answers) {
            answers = [];
        }

        const choices = answers.map(({a_id, a_text}) => {
            return (
                <li key={a_id}>
                    <label>
                        <input type="checkbox" name="choice" value={a_id} onChange={this.handleCheckboxChange}/>
                        {a_text}
                    </label>
                </li>
            )
        })

        return (
            <div>
                <p className="question-text">{q_text}</p>
                <form onSubmit={this.props.handleQuestionSubmit}>
                    <ul>{choices}</ul>
                    <input type="submit" value="submit"/>
                </form>
            </div>
        )
    }
}

class Base extends React.Component {
    constructor(props) {
        super(props);

        const email = localStorage.getItem('email') || '';
        const hash = localStorage.getItem('hash') || '';
        const haveAccount = !!email && !!hash;

        this.state = {
            email,
            hash,
            haveAccount,
            question: {},
            finalScore: undefined,
            choices: [],
        }

        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
        this.handleCheckboxChange = this.handleCheckboxChange.bind(this);
        this.handleQuestionSubmit = this.handleQuestionSubmit.bind(this);
    }

    async componentDidMount() {
        await this.updateQuestion();
    }

    async updateQuestion() {
        let result = {};
        try {
            result = await getQuestion(this.state.email, this.state.hash, {
                question: this.state.question?.q_id,
                choices: this.state.choices,
            });
        } catch (err) {
            console.log(err);
        }
        console.log(result);
        if (result.q_id) {
            this.setState({
                question: result,
                choices: [],
            })
        } else if (result.result) {
            this.setState({
                finalScore: result.result,
            })
        }
    }

    handleChange(email) {
        this.setState({
            email,
        })
    }

    handleSubmit(event) {
        event.preventDefault();
        axios.post(apiURL + '/api/users', {email: this.state.email})
            .then(async (result) => {
                saveToLocalStorage(result);
                this.setState({
                    haveAccount: true,
                    email: result.data.email,
                    hash: result.data.hash,
                });
                await this.updateQuestion();
            })
            .catch((err) => {
                console.log(err);
                alert("A problem occurred.");
            });
    }

    handleCheckboxChange(a_id) {
        const choices = this.state.choices.slice();
        const index = choices.indexOf(a_id);
        if (index !== -1) {
            choices.splice(index, 1);
        } else {
            choices.push(a_id);
        }
        this.setState({
           choices
        });
    }

    async handleQuestionSubmit(event) {
        event.preventDefault();
        await this.updateQuestion();
    }

    render() {
        const {email, haveAccount, question, finalScore} = this.state;
        if (haveAccount) {
            if (finalScore) {
                return <span className="score">Final score: <b>{finalScore}</b></span>
            } else {
                return (
                    <Question question={question} handleCheckboxChange={this.handleCheckboxChange}
                              handleQuestionSubmit={this.handleQuestionSubmit}/>
                );
            }
        } else {
            return (
                <RegisterForm email={email} handleChange={this.handleChange} handleSubmit={this.handleSubmit}/>
            );
        }
    }
}

ReactDOM.render(
    <Base/>,
    document.getElementById('root')
)

function saveToLocalStorage(response) {
    const {email, hash} = response.data;
    localStorage.setItem('email', email);
    localStorage.setItem('hash', hash);
}

async function getQuestion(email, hash, answer) {
    const data = {email, hash};
    if (answer.question) {
        data.answer = answer;
    }
    const res = await axios.post(apiURL + '/api/questions', data);
    return res.data;
}