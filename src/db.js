const { Pool } = require('pg');
const pool = new Pool({
    host: process.env.DB_HOST,
    port: Number(process.env.DB_PORT) || 5433,
    database: process.env.DB_NAME,
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    max: 10,
});
pool.on('error', (err) => {
    console.error('[db] Erro inesperado em conexão ociosa:', err.message);
});
async function checkConnection() {
    const { rows } = await pool.query(
        'SELECT current_database() AS database, NOW() AS server_time'
    );
    return rows[0];
}
module.exports = { pool, checkConnection };