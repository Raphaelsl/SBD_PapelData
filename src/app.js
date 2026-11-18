const path = require('path');
const express = require('express');
const indexRoutes = require('./routes/index');
const app = express();
//ejs
app.set('view engine', 'ejs');
app.set('views', path.join(__dirname, 'views'));
//imagens
app.use(express.static(path.join(__dirname, 'public')));
// Leitura de formulários HTML (POST) e JSON
app.use(express.urlencoded({ extended: true }));
app.use(express.json());
//rotes
app.use('/', indexRoutes);
// 404
app.use((req, res) => {
    res.status(404).render('404');
});
//tratador de erros
app.use((err, req, res, next) => {
    console.error('[erro]', err.message);
    res.status(500).render('error', {
        message: 'Não foi possível concluir a operação no banco de dados.',
    });
});
module.exports = app;