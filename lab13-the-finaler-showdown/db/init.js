const oracledb = require('oracledb');
const config = require('../config').db;
const debug = require('debug')('app:db:init');

let connection;

async function init() {
    connection = await oracledb.getConnection(config);
    debug('Database connection established.');
}

module.exports = {
    init,
    connection
};