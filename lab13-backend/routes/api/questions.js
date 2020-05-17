const { Router } = require('express');
const svc = require('../../services').question;

const router = Router();

router.post('/',
    async (req, res) => {
        const { email, hash, answer } = req.body;
        const result = await svc.nextQuestion(hash, email, answer);
        res.status(200).json(result);
    }
)

module.exports = router;