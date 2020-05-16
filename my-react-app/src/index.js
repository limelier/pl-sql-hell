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
                    Email:
                    <input
                        type="email"
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
    render() {
        let {q_text, answers} = this.props.question;
        if (!answers) {
            answers = [];
        }

        const answerButtons = answers.map(({a_id, a_text}) => {
            return (
                <li key={a_id}>
                    <button>{a_text}</button>
                </li>
            )
        })

        return (
            <div>
                <p className="question-text">{q_text}</p>
                <ol>{answerButtons}</ol>
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
        }

        this.handleChange = this.handleChange.bind(this);
        this.handleSubmit = this.handleSubmit.bind(this);
    }

    componentDidMount() {
        this.updateQuestion().then();
    }

    async updateQuestion() {
        let result = {};
        try {
            result = await getQuestion(this.state.email, this.state.hash);
        } catch (err) {
            console.log(err);
        }
        if (result.q_id) {
            this.setState({
                question: result
            })
        } else if (result.score) {
            this.setState({
                finalScore: result.score
            })
        }
    }

    handleChange(email) {
        this.setState({
            email,
        })
    }

    async handleSubmit(event) {
        event.preventDefault();
        axios.post(apiURL + '/api/users', {email: this.state.email})
            .then((result) => {
                saveToLocalStorage(result);
                this.setState({
                    haveAccount: true,
                });
            })
            .catch((err) => {
                console.log(err);
                alert("A problem occurred.");
            });
        this.updateQuestion().then();
    }

    render() {
        const {email, haveAccount, question} = this.state;
        if (haveAccount) {
            return (
                <Question question={question}/>
            );
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

async function getQuestion(email, hash) {
    const res = await axios.post(apiURL + '/api/questions', {email, hash});
    return res.data;
}