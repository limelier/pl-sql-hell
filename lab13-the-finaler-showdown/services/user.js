const crypto = require('crypto');
const db = require('../db').user;

const hash = crypto.createHash('sha256');

function hashEmail(email) {
    return hash
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