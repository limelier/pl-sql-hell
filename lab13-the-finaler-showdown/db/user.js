const oracledb = require('oracledb');

async function post(email, hash) {
    let conn;
    try {
        conn = await oracledb.getConnection();
        await conn.execute(
            'insert into test_users values (:hash, :email)',
            {hash, email},
            {autoCommit: true}
        )
    } finally {
        if (conn) {
            await conn.close();
        }
    }
}

async function exists(hash) {
    let conn;
    try {
        conn = await oracledb.getConnection();
        const result = await conn.execute(
                `select count(1)
                 from test_users
                 where hash = :hash`,
            {
                hash
            }
        );
        return result.rows[0][0] > 0;
    } finally {
        await conn.close();
    }
}

module.exports = {
    post,
    exists,
}