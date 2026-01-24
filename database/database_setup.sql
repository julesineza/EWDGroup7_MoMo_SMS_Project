-- Creating databases for project.

create database MoMo;

-- Use that database for creating tables

use MoMo;
SELECT DATABASE(); -- To make sure which database you are using

-- First we gonna create table for storing user's data (Is the main one)

create table USERS (
    user_id VARCHAR(20) PRIMARY KEY COMMENT 'Unique identifier  for each user, typically UUID string',
    full_name VARCHAR(100) NOT NULL COMMENT 'The legal names of the account holder',
    phone_number VARCHAR(30) NOT NULL UNIQUE COMMENT 'Unique phone number of the user',
    reg_date DATETIME COMMENT 'Registration date',
    last_transaction DATETIME COMMENT 'This is the date and time of the last transaction has been occured',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'This is when the transaction has been occured'
);

-- Records for the Users table

insert into USERS (user_id, full_name, phone_number, reg_date, last_transaction, created_at) VALUES
('u_01', 'Eddy BYIRINGIRO', '+250788381001', '2025-01-01 00:00:00', '2025-12-31 11:59:00', NOW()),
('u_02', 'Celine IRAKOZE', '+250788392002', '2025-03-15 09:36:35', '2025-11-28 13:41:30', NOW()),
('u_03', 'Jane GASINGE', '+250788403003', '2025-07-21 10:40:49', '2025-12-27 08:17:43', NOW()),
('u_04', 'Kellia INEZA', '+250788414004', '2025-08-08 11:55:28', '2025-12-02 15:22:37', NOW()),
('u_05', 'Angel MUGISHA', '+250788425005', '2025-05-25 12:18:47', '2026-01-22 17:30:19', NOW());

-- Create table of Transaction_category

create table TRANSACTION_CATEGORY (
    category_id VARCHAR(20) PRIMARY KEY COMMENT 'Unique identifier for each category, typically UUID string also',
    category_name VARCHAR(50) NOT NULL UNIQUE COMMENT 'Category of the transaction'
    category_type ENUM('Received', 'Send', 'Payment', 'Withdrawal', 'Deposit') COMMENT 'This is the type of transaction occured',
    description TEXT COMMENT 'This is a text message describing the transaction occured',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'This automatically generated time of when the transaction occured'
);

-- Records for Transaction_category table

insert into TRANSACTION_CATEGORY (category_id, category_name, category_type, description) VALUES
('CAT-P2P', 'Peer to peer', 'Send', 'Transferring money from two individual personal account'),
('CAT-DEP', 'Bank Deposit', 'Deposit', 'Moving money from a linked bank account to MoMo account'),
('CAT-BILL', 'Utility Bill', 'Payment', 'Paying for electricity, water, internet services or taxes'),
('CAT-WDR', 'Agent Withdrawal', 'Withdrawal', 'Taking out physical money from your MoMo wallet from an authorized MoMo agents'),
('CAT-SAL', 'Salary Deposit', 'Received', 'Monthly salary payment credited to the worker account');

-- Create table of Transactions

create table TRANSACTIONS (
    transaction_id VARCHAR(20) PRIMARY KEY COMMENT 'Unique identifier of each transaction, typically UUID string as well',
    sender_id VARCHAR(20) NOT NULL COMMENT 'Unique identifier of each sender, typically UUID string and also it is FOREIGN KEY from Users table'
    receiver_id VARCHAR(20) NOT NULL COMMENT 'Unique identifier of each receiver, typically UUID string and also it is FOREIGN KEY from Users table'
    category_id VARCHAR(20) NOT NULL COMMENT 'Unique identifier of each category, typically UUID string and also it is FOREIGN KEY  from Transaction_category table'
    amount DECIMAL(15, 2) NOT NULL COMMENT 'Transaction value',
    balance_before DECIMAL(15, 2) COMMENT 'This is the balance of user haved before any transaction happened',
    balance_after DECIMAL(15, 2) COMMENT 'Then this the updated balance of the user after any transaction happened',
    transaction_date DATETIME NOT NULL COMMENT 'This is when the transaction tooked place',
    message_sender VARCHAR(250) COMMENT 'Message from sender when any transaction happened',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'When that transaction happened',
    status ENUM('Completed', 'Pending', 'Failed', 'Reversed') COMMENT 'Status of the transaction',
    Foreign Key (sender_id) REFERENCES USERS (user_id),
    Foreign Key (receiver_id) REFERENCES USERS (user_id),
    Foreign Key (category_id) REFERENCES TRANSACTION_CATEGORY (category_id)

    
);

-- Records for Transactions table

INSERT INTO TRANSACTIONS (transaction_id, sender_id, receiver_id, category_id, amount, balance_before, balance_after, transaction_date, message_sender, status) VALUES
('TXN-001', 'u_01', 'u_02', 'CAT-P2P', 30000.00, 100000.00, 50000.00, NOW(), 'Transfering Money to Hannington', 'Completed'),
('TXN-002', 'u_02', 'u_03', 'CAT-P2P', 60000.50, 100000.00, 40000.00, NOW(), 'Reversing money from Kulio to Kevin', 'Pending'),
('TXN-003', 'u_03', 'u_04', 'CAT-BILL', 10000.00, 25000.00, 15000.00, NOW(), 'Airtime payment', 'Completed'),
('TXN-004', 'u_04', 'u_05', 'CAT-WDR', 5000.00, 10000.00, 5000.00, NOW(), 'Agent withdrawal', 'Failed'),
('TXN-005', 'u_05', 'u_01', 'CAT-DEP', 40000.00, 100000.00, 160000.00, NOW(), 'Bank deposit', 'Completed');

-- System Logs table
create table SYSTEM_LOGS (
    log_id VARCHAR(20) PRIMARY KEY COMMENT 'Unique Identifier',
    log_type ENUM('INFO', 'WARNING', 'ERROR', 'DEBUG') COMMENT 'Type of log when any action happened',
    message TEXT NOT NULL COMMENT 'Message of that log',
    user_id VARCHAR(20) NULL COMMENT 'User id which Foreign Key from USER table',
    transaction_id VARCHAR(20) NULL COMMENT 'Transaction id of that log (fk from transaction table)',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'When that log happened',
    Foreign Key (user_id) REFERENCES USERS (user_id),
    Foreign Key (transaction_id) REFERENCES TRANSACTIONS (transaction_id)

)

-- Records For The System Logs

insert into SYSTEM_LOGS(log_id, log_type, message, user_id, transaction_id) VALUES
('LOG-001', 'INFO', 'User logged in successfully', 'u_01', NULL),
('LOG-002', 'ERROR', 'Insufficient funds for transfer', 'u_02','TXN-005'),
('LOG-003', 'WARNING', 'Multiple failed login attempts detected', 'u_03', NULL),
('LOG-004', 'DEBUG', 'SMS gateway response: 200 OK', NULL, 'TXN-001'),
('LOG-005', 'INFO', 'Transaction completed successfully', 'u_05', 'TXN-004');

-- Transaction System Log Table (Many to Many Cardinality)
create table TRANSACTION_SYSTEM_LOG (
    system_log_id VARCHAR(20) PRIMARY KEY COMMENT 'Unique identifier'
    transaction_id VARCHAR(20) COMMENT 'Transaction id (fk from Transaction table)',
    log_id VARCHAR(20) COMMENT 'Log id (fk from System Logs table)',
    Foreign Key (transaction_id) REFERENCES TRANSACTIONS (transaction_id),
    Foreign Key (log_id) REFERENCES SYSTEM_LOGS(log_id)
);

-- Records for Transaction System Logs 

insert into TRANSACTION_SYSTEM_LOG (system_log_id, transaction_id, log_id) VALUES
('TSL-001', 'TXN-001', 'LOG-004'), -- Links a success txn to a success log
('TSL-002', 'TXN-004', 'LOG-002'), -- Links a failed txn to an error log
('TSL-003', 'TXN-005', 'LOG-005'), -- Links a bank deposit to a debug log
('TSL-004', 'TXN-002', 'LOG-004'), -- Another txn link
('TSL-005', 'TXN-003', 'LOG-005'); -- Linking a pending txn to a debug log

-- Indexes for faster read times in the tables.

CREATE INDEX idx_users_phone ON USERS(phone_number);
CREATE INDEX idx_transactions_sender ON TRANSACTIONS(sender_id);
CREATE INDEX idx_transactions_receiver ON TRANSACTIONS(receiver_id);
CREATE INDEX idx_transactions_date ON TRANSACTIONS(transaction_date);
CREATE INDEX idx_transactions_status ON TRANSACTIONS(status);
CREATE INDEX idx_system_logs_user ON SYSTEM_LOGS(user_id);

