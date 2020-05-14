const { Router } = require('express');
const apiRouter = require('./api');

const router = Router();

router.use('/api', apiRouter);
router.get('/status', (req, res) => {
    res.status(200).json('alive!');
})

module.exports = router;