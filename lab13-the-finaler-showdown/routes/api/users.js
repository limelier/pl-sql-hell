const { Router } = require('express');

const router = Router();

router.post('/',
    (req, res) => {
        res.status(200).json('alive');
    }
)

module.exports = router;