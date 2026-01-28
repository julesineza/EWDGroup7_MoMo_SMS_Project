-- Creating Database for the project

CREATE DATABASE MoMo;

-- Use that database to create tables

USE MoMo;

-- USERS TABLE (The Main one)

CREATE TABLE USERS (
    user_id VARCHAR(20) PRIMARY KEY COMMENT 'User identification',
    full_name VARCHAR(100) NOT NULL COMMENT 'Registered name of the user',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'Time the action tooked place'
);

INSERT INTO USERS (user_id, full_name) VALUES
('U101', 'Jane Smith'),
('U102', 'Samuel Carter'),
('U103', 'Direct Payment Ltd')
('U004', 'Diana Moore'),
('U005', 'Ethan Brown');




-- SYSTEM LOGS (RAW SMS) TABLE

CREATE TABLE SYSTEM_LOGS (
    log_id VARCHAR(20) PRIMARY KEY COMMENT 'Log identification',
    raw_body TEXT NOT NULL COMMENT 'Message of the action',
    received_at DATETIME NOT NULL COMMENT 'When that action has been received',
    processed_status ENUM('PENDING','PROCESSED','FAILED') DEFAULT 'PENDING' COMMENT 'Status of the action' 
);

INSERT INTO SYSTEM_LOGS (log_id, raw_body, received_at, processed_status) VALUES
('L1001', 'You have received 2000 RWF from Jane Smith (*********013) on your mobile money account at 2024-05-10 16:30:51. Message from sender: . Your new balance:2000 RWF. Financial Transaction Id: 76662021700.', '2024-05-10 16:30:51', 'PROCESSED'),
('L1002', 'TxId: 73214484437. Your payment of 1000 RWF to Jane Smith 12845 has been completed at 2024-05-10 16:31:39. Your new balance: 1000 RWF. Fee was 0 RWF.', '2024-05-10 16:31:39', 'PROCESSED'),
('L1003', 'TxId: 51732411227. Your payment of 600 RWF to Samuel Carter 95464 has been completed at 2024-05-10 21:32:32. Your new balance: 400 RWF. Fee was 0 RWF.', '2024-05-10 21:32:32', 'PROCESSED'),
('L1004', '*113*R*A bank deposit of 40000 RWF has been added to your mobile money account at 2024-05-11 18:43:49. Your NEW BALANCE :40400 RWF.', '2024-05-11 18:43:49', 'PROCESSED'),
('L1005', 'TxId: 17818959211. Your payment of 2000 RWF to Samuel Carter 14965 has been completed at 2024-05-11 18:48:42. Your new balance: 38400 RWF. Fee was 0 RWF.', '2024-05-11 18:48:42', 'PROCESSED');

-- TRANSACTIONS TABLE

CREATE TABLE TRANSACTIONS (
    transaction_id VARCHAR(20) PRIMARY KEY COMMENT 'Transaction identification',
    amount DECIMAL(12,2) NOT NULL CHECK (amount > 0) COMMENT 'Amount of the transaction',
    fee DECIMAL(10,2) DEFAULT 0 CHECK (fee >= 0) COMMENT 'Service fee of transaction',
    balance_after DECIMAL(12,2) COMMENT 'Updated balance after transaction',
    transaction_datetime DATETIME NOT NULL COMMENT 'When transaction happened',
    status ENUM('COMPLETED','FAILED','PENDING') COMMENT 'Status of the transaction',
    log_id VARCHAR(20) UNIQUE COMMENT 'FK from SYSTEM_LOGS',
    FOREIGN KEY (log_id) REFERENCES SYSTEM_LOGS(log_id)
);

INSERT INTO TRANSACTIONS (transaction_id, amount, fee, balance_after, transaction_datetime, status, log_id) VALUES
('76662021700', 2000, 0, 2000, '2024-05-10 16:30:51', 'COMPLETED', 'L1001'),
('73214484437', 1000, 0, 1000, '2024-05-10 16:31:39', 'COMPLETED', 'L1002'),
('51732411227', 600, 0, 400, '2024-05-10 21:32:32', 'COMPLETED', 'L1003'),
('D001', 40000, 0, 40400, '2024-05-11 18:43:49', 'COMPLETED', 'L1004'),
('17818959211', 2000, 0, 38400, '2024-05-11 18:48:42', 'COMPLETED', 'L1005');

-- TRANSACTION CATEGORY TABLE

CREATE TABLE TRANSACTION_CATEGORY (
    category_id VARCHAR(20) PRIMARY KEY COMMENT 'Category identification',
    category_name VARCHAR(50) UNIQUE NOT NULL COMMENT 'Name of the category',
    description TEXT COMMENT 'Description text'
);

INSERT INTO TRANSACTION_CATEGORY (category_id, category_name, description) VALUES
('C101', 'Payment Received', 'Money received from another user'),
('C102', 'Payment Sent', 'Money sent to another user'),
('C103', 'Bank Deposit', 'Deposit from bank into MoMo account'),
('C104', 'Airtime Purchase', 'Purchase of airtime or tokens'),
('C105', 'Refund', 'Refunds from failed transactions');

-- M:N TRANSACTION CATEGORY TABLE

CREATE TABLE TRANSACTION_CATEGORY_MAP (
    transaction_id VARCHAR(20) COMMENT 'Transaction identification',
    category_id VARCHAR(20) COMMENT 'FK from TRANSACTION_CATEGORY',
    PRIMARY KEY (transaction_id, category_id) COMMENT 'Identifications',
    FOREIGN KEY (transaction_id) REFERENCES TRANSACTIONS(transaction_id),
    FOREIGN KEY (category_id) REFERENCES TRANSACTION_CATEGORY(category_id)
);

INSERT INTO TRANSACTION_CATEGORY_MAP (transaction_id, category_id) VALUES
('76662021700', 'C101'),  -- received from Jane Smith
('73214484437', 'C102'),  -- payment to Jane Smith
('51732411227', 'C102'),  -- payment to Samuel Carter
('D001', 'C103'),          -- bank deposit
('17818959211', 'C102');  -- payment to Samuel Carter

-- TRANSACTION PARTICIPANTS TABLE

CREATE TABLE TRANSACTION_PARTICIPANTS (
    participant_id VARCHAR(20) PRIMARY KEY COMMENT 'Participant identification',
    transaction_id VARCHAR(20) COMMENT 'FK from TRANSACTION Table',
    user_id VARCHAR(20) COMMENT 'FK from USER Table',
    role ENUM('SENDER','RECEIVER') NOT NULL COMMENT 'Role of the user',
    FOREIGN KEY (transaction_id) REFERENCES TRANSACTIONS(transaction_id),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

INSERT INTO TRANSACTION_PARTICIPANTS (participant_id, transaction_id, user_id, role) VALUES
('P1001', '76662021700', 'U101', 'RECEIVER'),
('P1002', '73214484437', 'U101', 'RECEIVER'),
('P1003', '51732411227', 'U102', 'RECEIVER'),
('P1004', 'D001', 'U103', 'RECEIVER'),
('P1005', '17818959211', 'U102', 'RECEIVER');

-- INDEXES

CREATE INDEX idx_tx_date ON TRANSACTIONS(transaction_datetime);
CREATE INDEX idx_tx_status ON TRANSACTIONS(status)
