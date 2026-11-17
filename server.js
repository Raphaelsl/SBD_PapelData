require('dotenv').config({ quiet: true });
const app = require('./src/app');
const { checkConnection } = require('./src/db');
const PORT = Number(process.env.PORT) || 3000;
async function start() {
    try {
        const info = await checkConnection();
        console.log(`[db] Conectado ao banco "${info.database}"`);
    } catch (err) {
        console.error('[db] Não foi possível conectar ao PostgreSQL:', err.message);
        console.error('[db] Verifique o arquivo .env e se o PostgreSQL está rodando.');
        process.exit(1);
    }
    app.listen(PORT, () => {
        console.log(`[server] PapelData rodando em http://localhost:${PORT}`);
    });
}
start();