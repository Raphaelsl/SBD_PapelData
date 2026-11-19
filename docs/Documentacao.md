# Requisitos

| Campo | Descrição |
| :--- | :--- |
| **Nome do SBD** | **PapelData** — Sistema de Banco de Dados para Gestão de Papelaria, Gráfica Rápida e Listas de Material Escolar.<br><br>**Desenvolvimento:**<br>• Raphael Sousa Lameira — Matrícula: 25.1.8114 <br>• Ana Beatriz da Silva — Matrícula: 25.1.8134 |
| **Sobre o Projeto** | O **PapelData** é um Sistema de Banco de Dados (SBD) relacional com interface web desenvolvido para gerenciar de forma integrada o catálogo híbrido (produtos físicos e serviços de gráfica), o controle de estoque e fornecedores, a montagem e orçamento de listas de material escolar por instituição de ensino, o ponto de venda (PDV) e o acompanhamento de ordens de serviço de gráfica rápida. O sistema visa substituir controles manuais por uma base relacional íntegra, permitindo consultas gerenciais e operacionais em tempo real. |
| **Requisitos** | Os requisitos de dados, regras de negócio e funcionalidades atendidos pelo SBD estão detalhados a seguir. |

---

## Detalhamento dos Requisitos e Regras de Negócio

### 1. Cadastros Base (Clientes e Fornecedores)
* **RF01 — Gestão de Clientes (`CLIENTE`):** O sistema deve armazenar o identificador (`id_cliente`), `nome` (obrigatório), `cpf_cnpj` (único), `telefone`, `email` e `data_cadastro` (obrigatória).
* **RF02 — Gestão de Fornecedores (`FORNECEDOR`):** O sistema deve armazenar os fornecedores dos produtos de papelaria, contendo `id_fornecedor`, `razao_social` (obrigatória), `cnpj` (único e obrigatório), `telefone` e `email`.

### 2. Catálogo Unificado com Especialização (Produtos e Serviços)
* **RN01 — Herança/Especialização de Itens (`ITEM_CATALOGO`):** Todo item comercializado pela papelaria deve ser registrado em uma entidade pai `ITEM_CATALOGO`, contendo `id_item`, `nome` (obrigatório), `descricao`, `tipo_item` (restrito aos valores `'PRODUTO'` ou `'SERVICO'`) e flag `ativo` (padrão `TRUE`).
* **RF03 — Produtos Físicos (`PRODUTO`):** Especialização `1:1` de `ITEM_CATALOGO`. Deve registrar `cod_barras` (único), quantidade atual em estoque (`qtd_estoque`), alerta de estoque mínimo (`estoque_min`), `preco_custo`, `preco_venda` e o vínculo com seu fornecedor principal (`id_fornecedor`).
  * **RN02 — Controle de Estoque:** Nenhum produto pode ter `qtd_estoque` negativa, e o sistema deve destacar produtos cuja `qtd_estoque` esteja abaixo do `estoque_min`.
* **RF04 — Serviços de Gráfica Rápida (`SERVICO`):** Especialização `1:1` de `ITEM_CATALOGO` para serviços como impressão, encadernação, plastificação e plotagem. Deve armazenar o preço base por unidade (`preco_base_unid`) e o tempo estimado de execução em minutos (`tempo_min`).

### 3. Gestão de Escolas e Listas de Material Escolar
* **RF05 — Cadastro de Escolas (`ESCOLA`):** O sistema deve armazenar as instituições de ensino da região com `id_escola`, `nome_escola` (obrigatório) e `cidade`.
* **RF06 — Listas Escolares por Série e Ano (`LISTA_ESCOLAR`):** Uma escola pode possuir diversas listas escolares (`1:N`), identificadas por `id_lista`, vinculadas a `id_escola`, contendo o `ano_letivo` e a `serie_ano` (ex.: "5º Ano - Ensino Fundamental").
* **RN03 — Composição e Orçamento da Lista (`ITEM_LISTA_ESCOLAR`):** Relacionamento `N:M` entre `LISTA_ESCOLAR` e `PRODUTO`. Para cada produto da lista, deve-se armazenar a quantidade recomendada (`qtd_recomendada`) e se o item é `obrigatorio` (`BOOLEAN`). O sistema deve calcular automaticamente o orçamento atualizado da lista multiplicando a `qtd_recomendada` pelo `preco_venda` atual de cada produto.

### 4. Vendas de Balcão / PDV (`VENDA` e `ITEM_VENDA`)
* **RF07 — Registro de Vendas (`VENDA`):** Deve armazenar `id_venda`, data/hora (`data_venda`), `valor_total` e `forma_pagamento` (ex.: PIX, Cartão, Dinheiro).
  * **RN04 — Cliente Opcional no PDV:** Uma venda de balcão pode ser realizada para um cliente cadastrado (`id_cliente`) ou para um consumidor não identificado (`id_cliente` nulo, cardinalidade `(0,1)`).
* **RN05 — Histórico de Preços e Baixa de Estoque (`ITEM_VENDA`):** Relacionamento `N:M` entre `VENDA` e `ITEM_CATALOGO`. Deve registrar a quantidade vendida (`qtd`), o preço unitário praticado no momento exato da venda (`preco_uni_historico`) e o `subtotal`, garantindo que reajustes futuros no catálogo não alterem o histórico financeiro de vendas passadas. Quando o item vendido for do tipo `'PRODUTO'`, sua `qtd_estoque` deve ser decrementada transacionalmente.

### 5. Ordens de Serviço da Gráfica Rápida (`ORDEM_SERVICO` e `ITEM_ORDEM_SERVICO`)
* **RF08 — Abertura e Acompanhamento de OS (`ORDEM_SERVICO`):** Deve armazenar `id_os`, `id_cliente`, `data_abertura`, `data_encerra` (quando concluída), `status` (ex.: `'ABERTA'`, `'EM_EXECUCAO'`, `'CONCLUIDA'`, `'CANCELADA'`), `valor_total` e `observacoes`.
  * **RN06 — Cliente Obrigatório na OS:** Diferente da venda rápida de balcão, toda Ordem de Serviço exige obrigatoriamente um cliente vinculado (`id_cliente NOT NULL`, cardinalidade `(1,1)`), para controle de retirada e contato.
* **RN07 — Especificações Técnicas por Serviço (`ITEM_ORDEM_SERVICO`):** Relacionamento `N:M` entre `ORDEM_SERVICO` e `SERVICO`. Deve registrar a quantidade executada (`qtd`), o preço efetivamente aplicado (`preco_apli`) e as especificações técnicas do serviço (`espec_tec` — ex.: "Papel Couchê 180g, Colorido, Frente e Verso").

### 6. Requisitos de Consulta e Relatórios (Interface Web)
* **RF09 — Consultas Operacionais e Gerenciais:** A interface web deve permitir tanto a inserção/atualização de registros quanto a execução de consultas relacionais em SQL puro, incluindo:
  1. Alerta de produtos com estoque crítico (`qtd_estoque < estoque_min`) com dados do respectivo fornecedor;
  2. Consulta e cálculo de orçamento completo de listas escolares por escola e série;
  3. Painel de acompanhamento de Ordens de Serviço por status e por cliente;
  4. Relatório consolidado de faturamento e itens mais comercializados.

# Diagrama de Entidade e Relacionamento
[Modelo ER.pdf](https://github.com/user-attachments/files/34998710/Modelo.ER.pdf)
<img width="1007" height="837" alt="Captura de tela 2026-11-18 091439" src="https://github.com/user-attachments/assets/a71e04d1-e10a-491e-8113-2ebf5a7c0248" />



# Modelo Logico
[Modelo Relacional.pdf](https://github.com/user-attachments/files/35045692/Modelo.Relacional.pdf)  

<img width="500" height="528" alt="image" src="https://github.com/user-attachments/assets/c4477bce-cbe7-45bd-934c-e54f080e3fc3" />  

[Modelo_Lógico_Relacional.md](https://github.com/user-attachments/files/35045827/Modelo_Logico_Relacional.md)

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
