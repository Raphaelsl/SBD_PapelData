require('dotenv').config({ quiet: true });
const fs = require('fs');
const path = require('path');
const { pool } = require('../src/db');
async function runSqlFile(client, relativePath) {
    const fullPath = path.join(__dirname, '..', relativePath);
    const sql = fs.readFileSync(fullPath, 'utf8');
    console.log(`[db:setup] Executando ${relativePath}...`);
    await client.query(sql);
}
async function setupDatabase() {
    const client = await pool.connect();
    try {
        await client.query('BEGIN');
        await runSqlFile(client, 'sql/schema.sql');
        await runSqlFile(client, 'sql/seed.sql');
        await client.query('COMMIT');
        console.log('[db:setup] Banco de dados configurado e povoado com sucesso!');
    } catch (err) {
        await client.query('ROLLBACK');
        console.error('[db:setup] Erro ao executar scripts SQL:', err.message);
        process.exitCode = 1;
    } finally {
        client.release();
        await pool.end();
    }
}
setupDatabase();