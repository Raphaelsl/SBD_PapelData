# 📚 PapelData — Sistema de Banco de Dados (Papelaria & Gráfica Rápida)

Projeto de Implementação da disciplina **CSI602 – Banco de Dados I** (UFOP / ICEA / DECSI).

O **PapelData** é um Sistema de Banco de Dados (SBD) relacional com interface web desenvolvido para gerenciar as operações de uma **Papelaria e Gráfica Rápida**, incluindo controle de estoque de produtos, montagem e orçamento de **Listas de Material Escolar**, ordens de serviço de **Gráfica Rápida** e registro transacional de **Vendas**.

> **Nota sobre os requisitos da disciplina:** Toda a comunicação com o PostgreSQL é feita utilizando **exclusivamente SQL puro** através do driver `pg` (sem uso de ORMs ou query builders).

---

## 🛠️ Tecnologias Utilizadas

* **Backend:** Node.js + Express
* **Driver de Conexão (SQL Puro):** `pg` (node-postgres)
* **Interface Gráfica (Web):** EJS + Bootstrap 5

---

## 📂 Estrutura do Projeto

```text
SBD_PapelData/
├── docs/                  # Documentação (Etapa 1, Diagrama ER, Modelo Lógico)
├── sql/                   # Etapa 4: Scripts SQL
│   ├── schema.sql         # DDL (CREATE TABLE, PK, FK, CHECK, UNIQUE)
│   └── seed.sql           # DML (INSERT INTO com carga inicial de dados)
├── scripts/
│   └── db-setup.js        # Script para criar e povoar as tabelas automaticamente
├── src/
│   ├── db.js              # Pool de conexão com o PostgreSQL
│   ├── app.js             # Configuração do servidor Express e EJS
│   ├── repositories/      # Consultas e comandos em SQL puro
│   ├── routes/            # Rotas HTTP da aplicação
│   └── views/             # Telas web (EJS + Bootstrap)
├── server.js              # Ponto de entrada da aplicação
├── .env.example           # Modelo de variáveis de ambiente
└── package.json
```

---

## 🚀 Como Rodar o Projeto Localmente

### 1. Pré-requisitos
* **Node.js** (v20 ou superior)
* **PostgreSQL** instalado e em execução
* Um banco de dados vazio criado no PostgreSQL com o nome `papeldata`:
  ```sql
  CREATE DATABASE papeldata;
  ```

### 2. Clonar e instalar as dependências
```bash
git clone https://github.com/Raphaelsl/SBD_PapelData.git
cd SBD_PapelData
npm install
```

### 3. Configurar as variáveis de ambiente (`.env`)
Crie uma cópia do arquivo `.env.example` com o nome `.env` na raiz do projeto e preencha com a porta e a senha do seu PostgreSQL local:

```env
PORT=3000
DB_HOST=localhost
DB_PORT=5433
DB_NAME=papeldata
DB_USER=postgres
DB_PASSWORD=sua_senha_do_postgres
```

### 4. Criar as tabelas e popular o banco de dados
```bash
npm run db:setup
```

### 5. Iniciar a aplicação
* Em modo de desenvolvimento (com reinício automático):
  ```bash
  npm run dev
  ```
* Em modo padrão:
  ```bash
  npm start
  ```

Acesse no navegador: **`http://localhost:3000`**
