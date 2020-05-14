const oracledb = require('oracledb');

async function next(email, answer) {
    const conn = await oracledb.getConnection();
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
                maxSize: 4000
            }
        }
    )

    return JSON.parse(result.outBinds.ret);
}

module.exports = {
    next,
}