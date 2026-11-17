const express = require('express');
const indexRoutes = require('./routes/index');
const app = express();
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
app.use('/', indexRoutes);
app.use((req, res) => {
    res.status(404).send('Página não encontrada');
});
app.use((err, req, res, next) => {
    console.error('[erro]', err.message);
    res.status(500).send('Erro interno no servidor');
});
module.exports = app;