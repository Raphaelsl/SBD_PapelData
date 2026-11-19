-- ============================================================================
-- PapelData - Sistema de Banco de Dados para Papelaria & Gráfica Rápida
-- CSI602 - Banco de Dados I (UFOP)
-- Etapa 4: Script DML (Povoamento Inicial da Base de Dados)
-- ============================================================================

-- 1. CLIENTES
INSERT INTO cliente (nome, cpf_cnpj, telefone, email, data_cadastro) VALUES
('Patricia Lelis Alonso ', '123.456.789-01', '(31) 98811-2233', 'patricia.lelis@email.com', '2026-09-10'),
('Carlos Eduardo Ribeiro', '234.567.890-12', '(31) 98722-3344', 'cadu.ribeiro@email.com', '2026-09-18'),
('Fernanda Oliveira Lima', '345.678.901-23', '(31) 99133-4455', 'fernanda.lima@email.com', '2026-10-02'),
('Escritório Contábil Alfa Ltda', '12.345.678/0001-90', '(31) 3851-4000', 'compras@contabilalfa.com.br', '2026-10-15'),
('Lucas Mendes Martins', '456.789.012-34', '(31) 99244-5566', 'lucas.martins@email.com', '2026-11-01');

-- 2. FORNECEDORES
INSERT INTO fornecedor (razao_social, cnpj, telefone, email) VALUES
('Tilibra Produtos de Papelaria Ltda', '44.990.901/0001-43', '(14) 3235-4000', 'pedidos@tilibra.com.br'),
('A.W. Faber-Castell S.A.', '59.596.908/0001-52', '(16) 3362-5000', 'comercial@faber-castell.com.br'),
('Suzano Papel e Celulose S.A.', '16.404.287/0001-55', '(11) 3503-9000', 'vendas@suzano.com.br');

-- 3. ITENS DO CATÁLOGO (IDs 1 a 8 = PRODUTOS | IDs 9 a 13 = SERVIÇOS)
INSERT INTO item_catalogo (nome, descricao, tipo_item, ativo) VALUES
('Caderno Universitário 10 Matérias 200fls', 'Caderno espiral capa dura Tilibra Connect', 'PRODUTO', TRUE),
('Caixa Lápis de Cor 24 Cores', 'EcoLápis sextavado 24 cores vivas Faber-Castell', 'PRODUTO', TRUE),
('Caneta Esferográfica Azul 1.0mm', 'Caneta esferográfica escrita macia ponta média', 'PRODUTO', TRUE),
('Resma Papel Sulfite A4 75g (500 folhas)', 'Pacote 500 folhas A4 alcalino Suzano Report', 'PRODUTO', TRUE),
('Mochila Escolar Reforçada 30L', 'Mochila com compartimento para notebook e costura dupla', 'PRODUTO', TRUE),
('Cola Branca Líquida 90g', 'Cola escolar lavável não tóxica', 'PRODUTO', TRUE),
('Tesoura Escolar Sem Ponta Inox', 'Tesoura 13cm cabo anatômico com régua', 'PRODUTO', TRUE),
('Calculadora Científica 240 Funções', 'Visor de 2 linhas ideal para engenharia e exatas', 'PRODUTO', TRUE),
('Impressão Laser A4 Colorida', 'Impressão laser alta resolução em papel sulfite 90g ou couchê', 'SERVICO', TRUE),
('Impressão Laser A4 Preto e Branco', 'Impressão rápida P&B em sulfite A4 75g', 'SERVICO', TRUE),
('Encadernação Espiral (até 150 folhas)', 'Encadernação com capa transparente e contracapa preta/azul', 'SERVICO', TRUE),
('Plastificação de Documentos A4', 'Plastificação térmica rígida impermeável em polaseal', 'SERVICO', TRUE),
('Plotagem de Projetos A1 (Engenharia/Arquitetura)', 'Impressão de plantas técnicas em grande formato A1', 'SERVICO', TRUE);

-- 4. PRODUTOS (Especialização de ITEM_CATALOGO: IDs 1 a 8)
-- Obs.: Itens 2, 4 e 7 estão propositalmente com qtd_estoque < estoque_min para demonstrar o relatório de alerta!
INSERT INTO produto (id_item, cod_barras, qtd_estoque, estoque_min, preco_custo, preco_venda, id_fornecedor) VALUES
(1, '7891027110017', 45, 20, 18.50, 32.90, 1),
(2, '7891360220022', 8,  15, 22.00, 39.90, 2), -- Estoque crítico (8 < 15)
(3, '7891360330033', 120, 50, 0.95,  2.50,  2),
(4, '7891191440044', 6,  12, 21.00, 31.50, 3), -- Estoque crítico (6 < 12)
(5, '7891027550055', 14, 10, 75.00, 139.90, 1),
(6, '7891360660066', 35, 20, 2.80,  5.90,  2),
(7, '7891360770077', 5,  15, 4.50,  9.90,  2), -- Estoque crítico (5 < 15)
(8, '7891027880088', 18, 8,  38.00, 69.90, 1);

-- 5. SERVIÇOS (Especialização de ITEM_CATALOGO: IDs 9 a 13)
INSERT INTO servico (id_item, preco_base_unid, tempo_min) VALUES
(9,  2.50, 2),
(10, 0.50, 1),
(11, 8.00, 15),
(12, 5.00, 10),
(13, 18.00, 25);

-- 6. ESCOLAS
INSERT INTO escola (nome_escola, cidade) VALUES
('Colégio CEEP / Centro Educacional João Monlevade', 'João Monlevade'),
('Escola Estadual Luiz Prisco de Braga', 'João Monlevade'),
('Colégio Kennedy', 'João Monlevade');

-- 7. LISTAS ESCOLARES
INSERT INTO lista_escolar (id_escola, ano_letivo, serie_ano) VALUES
(1, 2027, '6º Ano - Ensino Fundamental'),
(2, 2027, '1º Ano - Ensino Médio'),
(3, 2027, '3º Ano - Ensino Fundamental');

-- 8. ITENS DAS LISTAS ESCOLARES (Relacionamento N:M Lista <-> Produto)
INSERT INTO item_lista_escolar (id_lista, id_item, qtd_recomendada, obrigatorio) VALUES
-- Lista 1 (6º Ano)
(1, 1, 2, TRUE),  -- 2 Cadernos 10 matérias
(1, 2, 1, TRUE),  -- 1 Caixa Lápis de Cor 24 cores
(1, 3, 4, TRUE),  -- 4 Canetas Azuis
(1, 6, 2, TRUE),  -- 2 Colas Brancas
(1, 7, 1, TRUE),  -- 1 Tesoura Sem Ponta
(1, 5, 1, FALSE), -- 1 Mochila (opcional)
-- Lista 2 (1º Ano EM)
(2, 1, 3, TRUE),  -- 3 Cadernos 10 matérias
(2, 3, 6, TRUE),  -- 6 Canetas Azuis
(2, 4, 1, TRUE),  -- 1 Resma A4
(2, 8, 1, TRUE),  -- 1 Calculadora Científica
-- Lista 3 (3º Ano EF)
(3, 2, 2, TRUE),  -- 2 Caixas Lápis de Cor
(3, 6, 3, TRUE),  -- 3 Colas Brancas
(3, 7, 1, TRUE);  -- 1 Tesoura Sem Ponta

-- 9. VENDAS (PDV - com e sem cliente identificado)
INSERT INTO venda (id_cliente, data_venda, valor_total, forma_pagamento) VALUES
(1, '2026-11-10 10:15:00', 115.70, 'PIX'),
(NULL, '2026-11-12 14:30:00', 42.80, 'DINHEIRO'), -- Venda de balcão sem cliente cadastrado
(4, '2026-11-14 16:45:00', 151.00, 'CARTAO_CREDITO'),
(2, '2026-11-16 09:20:00', 77.40, 'CARTAO_DEBITO');

-- 10. ITENS DE VENDA
INSERT INTO item_venda (id_venda, id_item, qtd, preco_uni_historico, subtotal) VALUES
-- Venda 1 (Mariana)
(1, 1, 2, 32.90, 65.80),
(1, 2, 1, 39.90, 39.90),
(1, 3, 4, 2.50,  10.00),
-- Venda 2 (Consumidor Balcão)
(2, 1, 1, 32.90, 32.90),
(2, 7, 1, 9.90,  9.90),
-- Venda 3 (Escritório Contábil Alfa)
(3, 4, 4, 31.50, 126.00),
(3, 3, 10, 2.50, 25.00),
-- Venda 4 (Carlos Eduardo)
(4, 8, 1, 69.90, 69.90),
(4, 10, 15, 0.50, 7.50);

-- 11. ORDENS DE SERVIÇO (Gráfica Rápida - exige cliente)
INSERT INTO ordem_servico (id_cliente, data_abertura, data_encerra, status, valor_total, observacoes) VALUES
(4, '2026-11-11 08:30:00', '2026-11-11', 'CONCLUIDA', 96.00, 'Relatórios contábeis anuais encadernados'),
(3, '2026-11-15 11:00:00', '2026-11-16', 'CONCLUIDA', 54.00, 'Plotagem de plantas arquitetônicas TCC'),
(5, '2026-11-18 14:10:00', NULL, 'EM_EXECUCAO', 41.00, 'Apostilas para concurso - cliente retira às 18h'),
(1, '2026-11-19 09:00:00', NULL, 'ABERTA', 25.00, 'Plastificação de crachás e certificados');

-- 12. ITENS DAS ORDENS DE SERVIÇO
INSERT INTO item_ordem_servico (id_os, id_servico, qtd, preco_apli, espec_tec) VALUES
-- OS 1
(1, 10, 120, 0.40, 'Impressão P&B frente e verso em papel A4 75g (desconto volume)'),
(1, 11, 6,   8.00, 'Encadernação espiral capa cristal e contracapa azul marinho'),
-- OS 2
(2, 13, 3,   18.00, 'Plotagem A1 colorida em papel sulfite 90g - escala 1:50'),
-- OS 3
(3, 10, 50,  0.50, 'Impressão P&B frente simples'),
(3, 11, 2,   8.00, 'Encadernação espiral preta'),
-- OS 4
(4, 12, 5,   5.00, 'Plastificação A4 polaseal 0,07mm brilhante');