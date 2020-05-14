const oracledb = require('oracledb');

async function post(email, hash) {
    const conn = await oracledb.getConnection();
    await conn.execute(
        'insert into test_users values (:hash, :email)',
        {hash, email},
        {autoCommit: true}
    )
}

module.exports = {
    post,
}