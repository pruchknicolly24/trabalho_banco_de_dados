DROP DATABASE IF EXISTS loja_maquiagem;
CREATE DATABASE loja_maquiagem;
USE loja_maquiagem;

CREATE TABLE clientes (
    id_cliente INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL,
    telefone VARCHAR(20) NOT NULL
);

CREATE TABLE produtos (
    id_produto INT AUTO_INCREMENT PRIMARY KEY,
    nome VARCHAR(100) NOT NULL,
    preco DECIMAL(10,2) NOT NULL,
    estoque INT NOT NULL
);

CREATE TABLE pedidos (
    id_pedido INT AUTO_INCREMENT PRIMARY KEY,
    id_cliente INT NOT NULL,
    data_pedido DATE NOT NULL,
    FOREIGN KEY (id_cliente) REFERENCES clientes(id_cliente)
);

CREATE TABLE itens_pedido (
    id_item INT AUTO_INCREMENT PRIMARY KEY,
    id_pedido INT NOT NULL,
    id_produto INT NOT NULL,
    quantidade INT NOT NULL,
    preco_unitario DECIMAL(10,2) NOT NULL,
    FOREIGN KEY (id_pedido) REFERENCES pedidos(id_pedido),
    FOREIGN KEY (id_produto) REFERENCES produtos(id_produto)
);

INSERT INTO clientes (nome, email, telefone) VALUES
('Nicolly Pruchak', 'nicolly.p@gmail.com', '(41) 99999-1234'),
('Larissa Souza', 'lari.s@gmail.com', '(41) 98888-5678');

INSERT INTO produtos (nome, preco, estoque) VALUES
('Batom Vermelho', 24.90, 30),
('Base Clara', 39.90, 15),
('Rímel Preto', 19.90, 50);

INSERT INTO pedidos (id_cliente, data_pedido) VALUES
(1, '2025-06-20'),
(2, '2025-06-21');

INSERT INTO itens_pedido (id_pedido, id_produto, quantidade, preco_unitario) VALUES
(1, 1, 2, 24.90),
(1, 2, 1, 39.90),
(2, 3, 3, 19.90);


SELECT 
  p.id_pedido,
  c.nome AS cliente,
  p.data_pedido,
  SUM(i.quantidade * i.preco_unitario) AS total
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN itens_pedido i ON p.id_pedido = i.id_pedido
GROUP BY p.id_pedido, c.nome, p.data_pedido;

SELECT nome, preco, estoque FROM produtos WHERE estoque > 20;

SELECT i.id_item, p.nome AS produto, i.quantidade, i.preco_unitario
FROM itens_pedido i
JOIN produtos p ON i.id_produto = p.id_produto;


SELECT nome FROM clientes
WHERE id_cliente IN (
    SELECT id_cliente FROM pedidos
);

SELECT nome FROM produtos
WHERE id_produto IN (
    SELECT id_produto FROM itens_pedido
);


CREATE OR REPLACE VIEW vw_pedidos_cliente AS
SELECT 
    p.id_pedido,
    c.nome AS cliente,
    p.data_pedido,
    SUM(i.quantidade * i.preco_unitario) AS total_pedido
FROM pedidos p
JOIN clientes c ON p.id_cliente = c.id_cliente
JOIN itens_pedido i ON p.id_pedido = i.id_pedido
GROUP BY p.id_pedido, c.nome, p.data_pedido;

SELECT * FROM vw_pedidos_cliente;


SELECT SUM(i.quantidade * i.preco_unitario) AS total_vendas FROM itens_pedido i;

SELECT AVG(preco) AS preco_medio FROM produtos;
