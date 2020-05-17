const crypto = require('crypto');
const db = require('../db').user;

function hashEmail(email) {
    return crypto
        .createHash('sha256')
        .update(email + Date.now())
        .digest('hex');
}

async function post(email) {
    const hash = hashEmail(email);
    await db.post(email, hash);
    return {hash, email};
}

module.exports = {
    post,
}