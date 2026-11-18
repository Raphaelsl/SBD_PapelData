# Requisitos

# Diagrama de Entidade e Relacionamento
[Modelo ER.pdf](https://github.com/user-attachments/files/34998710/Modelo.ER.pdf)
<img width="1007" height="837" alt="Captura de tela 2026-11-18 091439" src="https://github.com/user-attachments/assets/a71e04d1-e10a-491e-8113-2ebf5a7c0248" />



# Modelo Logico
[Modelo Relacional.pdf](https://github.com/user-attachments/files/35045692/Modelo.Relacional.pdf)[Modelo_Lógico_Relacional.md](https://github.com/user-attachments/files/35045827/Modelo_Logico_Relacional.md)

## 1. Cadastros Principais

* **CLIENTE**
  * `id_cliente` (INT) [PK]
  * `nome` (VARCHAR(100)) [NOT NULL]
  * `cpf_cnpj` (VARCHAR(18)) [UNIQUE]
  * `telefone` (VARCHAR(20))
  * `email` (VARCHAR(100))
  * `data_cadastro` (DATE) [NOT NULL]

* **FORNECEDOR**
  * `id_fornecedor` (INT) [PK]
  * `razao_social` (VARCHAR(100)) [NOT NULL]
  * `cnpj` (VARCHAR(18)) [UNIQUE, NOT NULL]
  * `telefone` (VARCHAR(20))
  * `email` (VARCHAR(100))

---

## 2. Especialização (Herança)

* **ITEM_CATALOGO** (Tabela Pai)
  * `id_item` (INT) [PK]
  * `nome` (VARCHAR(100)) [NOT NULL]
  * `descricao` (TEXT)
  * `tipo_item` (VARCHAR(10)) [CHECK: 'PRODUTO' ou 'SERVICO']
  * `ativo` (BOOLEAN) [DEFAULT TRUE]

* **PRODUTO** (Filha 1:1)
  * `id_item` (INT) [PK, FK -> ITEM_CATALOGO.id_item]
  * `cod_barras` (VARCHAR(50)) [UNIQUE]
  * `qtd_estoque` (INT) [NOT NULL]
  * `estoque_min` (INT) [NOT NULL]
  * `preco_custo` (DECIMAL(10,2)) [NOT NULL]
  * `preco_venda` (DECIMAL(10,2)) [NOT NULL]
  * `id_fornecedor` (INT) [FK -> FORNECEDOR.id_fornecedor]

* **SERVICO** (Filha 1:1)
  * `id_item` (INT) [PK, FK -> ITEM_CATALOGO.id_item]
  * `preco_base_unid` (DECIMAL(10,2)) [NOT NULL]
  * `tempo_min` (INT)

---

## 3. Listas Escolares

* **ESCOLA**
  * `id_escola` (INT) [PK]
  * `nome_escola` (VARCHAR(100)) [NOT NULL]
  * `cidade` (VARCHAR(50))

* **LISTA_ESCOLAR**
  * `id_lista` (INT) [PK]
  * `id_escola` (INT) [FK -> ESCOLA.id_escola]
  * `ano_letivo` (INT) [NOT NULL]
  * `serie_ano` (VARCHAR(50)) [NOT NULL]

* **ITEM_LISTA_ESCOLAR** (Associativa N:M)
  * `id_lista` (INT) [PK, FK -> LISTA_ESCOLAR.id_lista]
  * `id_item_produto` (INT) [PK, FK -> PRODUTO.id_item]
  * `qtd_recomendada` (INT) [NOT NULL]
  * `obrigatorio` (BOOLEAN) [DEFAULT TRUE]

---

## 4. Vendas (PDV) e Ordens de Serviço (Gráfica)

* **VENDA**
  * `id_venda` (INT) [PK]
  * `id_cliente` (INT) [FK -> CLIENTE.id_cliente, NULLABLE]
  * `data_venda` (TIMESTAMP) [NOT NULL]
  * `valor_total` (DECIMAL(10,2)) [NOT NULL]
  * `forma_pagamento` (VARCHAR(20)) [NOT NULL]

* **ITEM_VENDA** (Associativa N:M)
  * `id_venda` (INT) [PK, FK -> VENDA.id_venda]
  * `id_item` (INT) [PK, FK -> ITEM_CATALOGO.id_item]
  * `qtd` (INT) [NOT NULL]
  * `preco_uni_historico` (DECIMAL(10,2)) [NOT NULL]
  * `subtotal` (DECIMAL(10,2)) [NOT NULL]

* **ORDEM_SERVICO**
  * `id_os` (INT) [PK]
  * `id_cliente` (INT) [FK -> CLIENTE.id_cliente]
  * `data_abertura` (TIMESTAMP) [NOT NULL]
  * `data_encerra` (DATE)
  * `status` (VARCHAR(25)) [NOT NULL]
  * `valor_total` (DECIMAL(10,2)) [NOT NULL]
  * `observacoes` (TEXT)

* **ITEM_ORDEM_SERVICO** (Associativa N:M)
  * `id_os` (INT) [PK, FK -> ORDEM_SERVICO.id_os]
  * `id_servico` (INT) [PK, FK -> SERVICO.id_item]
  * `qtd` (INT) [NOT NULL]
  * `preco_apli` (DECIMAL(10,2)) [NOT NULL]
  * `espec_tec` (TEXT)
