-- Criando a base de dados
CREATE DATABASE CarRepairShop;
USE CarRepairShop;

-- Tabela de Clientes (Cliente PF e PJ)
CREATE TABLE Clients (
    idClient INT AUTO_INCREMENT PRIMARY KEY,
    clientName VARCHAR(50),
    clientType ENUM('PF', 'PJ'), -- Pessoa Física (PF) ou Pessoa Jurídica (PJ)
    CPF_CNPJ VARCHAR(18) UNIQUE,
    Address VARCHAR(100)
);

-- Tabela de Funcionários (Mecânicos)
CREATE TABLE Mechanics (
    idMechanic INT AUTO_INCREMENT PRIMARY KEY,
    mechanicName VARCHAR(50),
    specialty VARCHAR(30)
);

-- Tabela de Serviços (Tipos de serviço oferecidos)
CREATE TABLE Services (
    idService INT AUTO_INCREMENT PRIMARY KEY,
    serviceName VARCHAR(50),
    price DECIMAL(10, 2)
);

-- Tabela de Pedidos (Ordens de serviço)
CREATE TABLE Orders (
    idOrder INT AUTO_INCREMENT PRIMARY KEY,
    idClient INT,
    idMechanic INT,
    serviceDate DATE,
    serviceStatus ENUM('Em andamento', 'Concluído', 'Cancelado'),
    paymentStatus ENUM('Pendente', 'Pago'),
    trackingCode VARCHAR(50),
    FOREIGN KEY (idClient) REFERENCES Clients(idClient),
    FOREIGN KEY (idMechanic) REFERENCES Mechanics(idMechanic)
);

-- Tabela de Pagamentos (Várias formas de pagamento por pedido)
CREATE TABLE Payments (
    idPayment INT AUTO_INCREMENT PRIMARY KEY,
    idOrder INT,
    paymentMethod ENUM('Cartão de Crédito', 'Cartão de Débito', 'Dinheiro', 'Pix', 'Transferência'),
    paymentAmount DECIMAL(10, 2),
    FOREIGN KEY (idOrder) REFERENCES Orders(idOrder)
);

-- Tabela de Estoque (Produtos utilizados nos serviços)
CREATE TABLE Inventory (
    idProduct INT AUTO_INCREMENT PRIMARY KEY,
    productName VARCHAR(50),
    stockQuantity INT
);

-- Tabela de Fornecedores
CREATE TABLE Suppliers (
    idSupplier INT AUTO_INCREMENT PRIMARY KEY,
    supplierName VARCHAR(50),
    contactInfo VARCHAR(50)
);

-- Tabela de Produtos por Fornecedor
CREATE TABLE ProductSupplier (
    idSupplier INT,
    idProduct INT,
    supplyQuantity INT,
    PRIMARY KEY (idSupplier, idProduct),
    FOREIGN KEY (idSupplier) REFERENCES Suppliers(idSupplier),
    FOREIGN KEY (idProduct) REFERENCES Inventory(idProduct)
);

-- Inserindo clientes
INSERT INTO Clients (clientName, clientType, CPF_CNPJ, Address)
VALUES ('João Silva', 'PF', '12345678900', 'Rua das Flores, 123'),
       ('Auto Center LTDA', 'PJ', '98765432000199', 'Avenida Principal, 1000');

-- Inserindo mecânicos
INSERT INTO Mechanics (mechanicName, specialty)
VALUES ('Carlos Mendes', 'Freios'),
       ('Fernanda Lima', 'Suspensão');

-- Inserindo serviços
INSERT INTO Services (serviceName, price)
VALUES ('Troca de óleo', 150.00),
       ('Alinhamento e balanceamento', 200.00);

-- Inserindo ordens de serviço
INSERT INTO Orders (idClient, idMechanic, serviceDate, serviceStatus, paymentStatus, trackingCode)
VALUES (1, 1, '2024-10-03', 'Concluído', 'Pago', 'ABC12345'),
       (2, 2, '2024-10-02', 'Em andamento', 'Pendente', 'DEF67890');

-- Inserindo pagamentos
INSERT INTO Payments (idOrder, paymentMethod, paymentAmount)
VALUES (1, 'Cartão de Crédito', 150.00),
       (2, 'Pix', 200.00);

-- Inserindo estoque
INSERT INTO Inventory (productName, stockQuantity)
VALUES ('Óleo 5W30', 50),
       ('Filtro de óleo', 30);

-- Inserindo fornecedores
INSERT INTO Suppliers (supplierName, contactInfo)
VALUES ('Fornecedor A', 'email@fornecedorA.com'),
       ('Fornecedor B', 'email@fornecedorB.com');

-- Relacionando produtos com fornecedores
INSERT INTO ProductSupplier (idSupplier, idProduct, supplyQuantity)
VALUES (1, 1, 20),
       (2, 2, 15);

-- 1. Quantos pedidos foram feitos por cada cliente?
SELECT clientName, COUNT(idOrder) AS totalOrders
FROM Clients
JOIN Orders ON Clients.idClient = Orders.idClient
GROUP BY clientName;

-- 2. Algum fornecedor também é cliente?
SELECT supplierName
FROM Suppliers
JOIN Clients ON Suppliers.supplierName = Clients.clientName;

-- 3. Relação de produtos e fornecedores
SELECT productName, supplierName, supplyQuantity
FROM Inventory
JOIN ProductSupplier ON Inventory.idProduct = ProductSupplier.idProduct
JOIN Suppliers ON ProductSupplier.idSupplier = Suppliers.idSupplier;

-- 4. Relação de serviços e mecânicos
SELECT serviceName, mechanicName
FROM Services
JOIN Orders ON Services.idService = Orders.idService
JOIN Mechanics ON Orders.idMechanic = Mechanics.idMechanic;
