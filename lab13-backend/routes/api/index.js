const { Router } = require('express');
const userRouter = require('./users');
const questionRouter = require('./questions');

const router = Router();

router.use('/users', userRouter);
router.use('/questions', questionRouter);

module.exports = router;