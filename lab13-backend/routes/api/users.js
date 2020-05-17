const { Router } = require('express');
const svc = require('../../services').user;

const router = Router();

router.post('/',
    async (req, res) => {
        const { email } = req.body;
        const result = await svc.post(email);
        res.status(201).json(result);
    }
)

module.exports = router;