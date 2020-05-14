const db = require('../db');

async function nextQuestion(hash, email, answer) {
    const userExists = await db.user.exists(hash);

    if (userExists) {
        let answerString;
        if (answer) {
            answerString = answer.question + ':' + answer.choices.join();
        } else {
            answerString = null;
        }
        return db.question.next(email, answerString);
    } else {
        return { error: 'Bad hash.'};
    }
}

module.exports = {
    nextQuestion,
}