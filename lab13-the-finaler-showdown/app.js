const express = require('express');
const debug = require('debug')('app');

const initDb = require('./db').init;
const router = require('./routes');
const config = require('./config').express;

(async function () {
    try {
        await initDb();
    } catch (err) {
        debug(err);
        debug('Database connection could not be established, aborting.');
        return;
    }
    const app = express();
    app.use(express.json())
    app.use(router);

    app.listen(config.port, (err) => {
        if (err) {
            debug(err);
            throw new Error('app.listen');
        }
        debug(`Server up and listening on port ${config.port}...`)
    });
})();