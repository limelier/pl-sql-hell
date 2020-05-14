const oracledb = require('oracledb');
const config = require('../config').db;
const debug = require('debug')('app:db:init');

async function init() {
    await oracledb.createPool(config);
    debug('Pool created.');
}

module.exports = init;