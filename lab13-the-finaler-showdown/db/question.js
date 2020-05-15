const oracledb = require('oracledb');

async function next(email, answer) {
    let conn;
    try {
        conn = await oracledb.getConnection();
        const result = await conn.execute(
            `begin
            :ret := next_question(:email, :answer);
            end;`,
            {
                email,
                answer,
                ret: {
                    dir: oracledb.BIND_OUT,
                    type: oracledb.STRING,
                    maxSize: 4000,
                },
            },
            {
                autoCommit: true
            }
        );
        return JSON.parse(result.outBinds.ret);
    } finally {
        if (conn) {
            await conn.close();
        }
    }
}

module.exports = {
    next,
}