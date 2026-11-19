-- ============================================================================
-- PapelData - Sistema de Banco de Dados para Papelaria & Gráfica Rápida
-- CSI602 - Banco de Dados I (UFOP)
-- Etapa 4: Script DDL (Criação do Esquema Relacional - 12 Tabelas)
-- ============================================================================
DROP TABLE IF EXISTS item_ordem_servico CASCADE;
DROP TABLE IF EXISTS ordem_servico CASCADE;
DROP TABLE IF EXISTS item_venda CASCADE;
DROP TABLE IF EXISTS venda CASCADE;
DROP TABLE IF EXISTS item_lista_escolar CASCADE;
DROP TABLE IF EXISTS lista_escolar CASCADE;
DROP TABLE IF EXISTS escola CASCADE;
DROP TABLE IF EXISTS servico CASCADE;
DROP TABLE IF EXISTS produto CASCADE;
DROP TABLE IF EXISTS item_catalogo CASCADE;
DROP TABLE IF EXISTS fornecedor CASCADE;
DROP TABLE IF EXISTS cliente CASCADE;
-- ============================================================================
-- 1. CADASTROS PRINCIPAIS
-- ============================================================================
CREATE TABLE cliente (
    id_cliente    SERIAL PRIMARY KEY,
    nome          VARCHAR(100) NOT NULL,
    cpf_cnpj      VARCHAR(18) UNIQUE,
    telefone      VARCHAR(20),
    email         VARCHAR(100),
    data_cadastro DATE NOT NULL DEFAULT CURRENT_DATE
);
CREATE TABLE fornecedor (
    id_fornecedor SERIAL PRIMARY KEY,
    razao_social  VARCHAR(100) NOT NULL,
    cnpj          VARCHAR(18) NOT NULL UNIQUE,
    telefone      VARCHAR(20),
    email         VARCHAR(100)
);
-- ============================================================================
-- 2. ESPECIALIZAÇÃO / HERANÇA (CATÁLOGO: PRODUTO E SERVIÇO)
-- ============================================================================
CREATE TABLE item_catalogo (
    id_item   SERIAL PRIMARY KEY,
    nome      VARCHAR(100) NOT NULL,
    descricao VARCHAR (255),
    tipo_item VARCHAR(10) NOT NULL CHECK (tipo_item IN ('PRODUTO', 'SERVICO')),
    ativo     BOOLEAN NOT NULL DEFAULT TRUE
);
CREATE TABLE produto (
    id_item       INT PRIMARY KEY,
    cod_barras    VARCHAR(50) UNIQUE,
    qtd_estoque   INT NOT NULL CHECK (qtd_estoque >= 0),
    estoque_min   INT NOT NULL CHECK (estoque_min >= 0),
    preco_custo   DECIMAL(10,2) NOT NULL CHECK (preco_custo >= 0),
    preco_venda   DECIMAL(10,2) NOT NULL CHECK (preco_venda >= 0),
    id_fornecedor INT NOT NULL,
    CONSTRAINT fk_produto_item
        FOREIGN KEY (id_item) REFERENCES item_catalogo(id_item) ON DELETE CASCADE,
    CONSTRAINT fk_produto_fornecedor
        FOREIGN KEY (id_fornecedor) REFERENCES fornecedor(id_fornecedor)
);
CREATE TABLE servico (
    id_item         INT PRIMARY KEY,
    preco_base_unid DECIMAL(10,2) NOT NULL CHECK (preco_base_unid >= 0),
    tempo_min       INT CHECK (tempo_min > 0),
    CONSTRAINT fk_servico_item
        FOREIGN KEY (id_item) REFERENCES item_catalogo(id_item) ON DELETE CASCADE
);
-- ============================================================================
-- 3. LISTAS ESCOLARES
-- ============================================================================
CREATE TABLE escola (
    id_escola   SERIAL PRIMARY KEY,
    nome_escola VARCHAR(100) NOT NULL,
    cidade      VARCHAR(50)
);
CREATE TABLE lista_escolar (
    id_lista   SERIAL PRIMARY KEY,
    id_escola  INT NOT NULL,
    ano_letivo INT NOT NULL,
    serie_ano  VARCHAR(50) NOT NULL,
    CONSTRAINT fk_lista_escola
        FOREIGN KEY (id_escola) REFERENCES escola(id_escola) ON DELETE CASCADE
);
CREATE TABLE item_lista_escolar (
    id_lista        INT NOT NULL,
    id_item INT NOT NULL,
    qtd_recomendada INT NOT NULL CHECK (qtd_recomendada > 0),
    obrigatorio     BOOLEAN NOT NULL DEFAULT TRUE,
    PRIMARY KEY (id_lista, id_item),
    CONSTRAINT fk_item_lista_lista
        FOREIGN KEY (id_lista) REFERENCES lista_escolar(id_lista) ON DELETE CASCADE,
    CONSTRAINT fk_item_lista_produto
        FOREIGN KEY (id_item) REFERENCES produto(id_item)
);
-- ============================================================================
-- 4. VENDAS (PDV) E ORDENS DE SERVIÇO (GRÁFICA RÁPIDA)
-- ============================================================================
CREATE TABLE venda (
    id_venda        SERIAL PRIMARY KEY,
    id_cliente      INT,
    data_venda      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    valor_total     DECIMAL(10,2) NOT NULL CHECK (valor_total >= 0),
    forma_pagamento VARCHAR(20) NOT NULL,
    CONSTRAINT fk_venda_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente) ON DELETE SET NULL
);
CREATE TABLE item_venda (
    id_venda            INT NOT NULL,
    id_item             INT NOT NULL,
    qtd                 INT NOT NULL CHECK (qtd > 0),
    preco_uni_historico DECIMAL(10,2) NOT NULL CHECK (preco_uni_historico >= 0),
    subtotal            DECIMAL(10,2) NOT NULL CHECK (subtotal >= 0),
    PRIMARY KEY (id_venda, id_item),
    CONSTRAINT fk_item_venda_venda
        FOREIGN KEY (id_venda) REFERENCES venda(id_venda) ON DELETE CASCADE,
    CONSTRAINT fk_item_venda_catalogo
        FOREIGN KEY (id_item) REFERENCES item_catalogo(id_item)
);
CREATE TABLE ordem_servico (
    id_os         SERIAL PRIMARY KEY,
    id_cliente    INT NOT NULL,
    data_abertura TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    data_encerra  DATE,
    status        VARCHAR(25) NOT NULL CHECK (status IN ('ABERTA', 'EM_EXECUCAO', 'CONCLUIDA', 'CANCELADA')),
    valor_total   DECIMAL(10,2) NOT NULL CHECK (valor_total >= 0),
    observacoes   VARCHAR(255),
    CONSTRAINT fk_os_cliente
        FOREIGN KEY (id_cliente) REFERENCES cliente(id_cliente)
);
CREATE TABLE item_ordem_servico (
    id_os      INT NOT NULL,
    id_servico INT NOT NULL,
    qtd        INT NOT NULL CHECK (qtd > 0),
    preco_apli DECIMAL(10,2) NOT NULL CHECK (preco_apli >= 0),
    espec_tec  VARCHAR(255),
    PRIMARY KEY (id_os, id_servico),
    CONSTRAINT fk_item_os_os
        FOREIGN KEY (id_os) REFERENCES ordem_servico(id_os) ON DELETE CASCADE,
    CONSTRAINT fk_item_os_servico
        FOREIGN KEY (id_servico) REFERENCES servico(id_item)
);