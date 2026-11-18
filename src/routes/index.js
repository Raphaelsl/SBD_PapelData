const express = require('express');
const { checkConnection } = require('../db');
const router = express.Router();
router.get('/', async (req, res, next) => {
    try {
        const dbInfo = await checkConnection();
        res.render('index', { dbInfo });
    } catch (err) {
        next(err);
    }
});
router.get('/health', async (req, res) => {
    try {
        const info = await checkConnection();
        res.json({
            status: 'ok',
            database: info.database,
            serverTime: info.server_time,
        });
    } catch (err) {
        console.error('[health] Falha ao conectar no banco:', err.message);
        res.status(503).json({
            status: 'error',
            message: 'Banco de dados indisponível',
        });
    }
});
module.exports = router;