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

-- SYSTEM LOGS (RAW SMS) TABLE

CREATE TABLE SYSTEM_LOGS (
    log_id VARCHAR(20) PRIMARY KEY COMMENT 'Log identification',
    raw_body TEXT NOT NULL COMMENT 'Message of the action',
    received_at DATETIME NOT NULL COMMENT 'When that action has been received',
    processed_status ENUM('PENDING','PROCESSED','FAILED') DEFAULT 'PENDING' COMMENT 'Status of the action' 
);

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

-- TRANSACTION CATEGORY TABLE

CREATE TABLE TRANSACTION_CATEGORY (
    category_id VARCHAR(20) PRIMARY KEY COMMENT 'Category identification',
    category_name VARCHAR(50) UNIQUE NOT NULL COMMENT 'Name of the category',
    description TEXT COMMENT 'Description text'
);

-- M:N TRANSACTION CATEGORY TABLE

CREATE TABLE TRANSACTION_CATEGORY_MAP (
    transaction_id VARCHAR(20) COMMENT 'Transaction identification',
    category_id VARCHAR(20) COMMENT 'FK from TRANSACTION_CATEGORY',
    PRIMARY KEY (transaction_id, category_id) COMMENT 'Identifications',
    FOREIGN KEY (transaction_id) REFERENCES TRANSACTIONS(transaction_id),
    FOREIGN KEY (category_id) REFERENCES TRANSACTION_CATEGORY(category_id)
);

-- TRANSACTION PARTICIPANTS TABLE

CREATE TABLE TRANSACTION_PARTICIPANTS (
    participant_id VARCHAR(20) PRIMARY KEY COMMENT 'Participant identification',
    transaction_id VARCHAR(20) COMMENT 'FK from TRANSACTION Table',
    user_id VARCHAR(20) COMMENT 'FK from USER Table',
    role ENUM('SENDER','RECEIVER') NOT NULL COMMENT 'Role of the user',
    FOREIGN KEY (transaction_id) REFERENCES TRANSACTIONS(transaction_id),
    FOREIGN KEY (user_id) REFERENCES USERS(user_id)
);

-- INDEXES

CREATE INDEX idx_tx_date ON TRANSACTIONS(transaction_datetime);
CREATE INDEX idx_tx_status ON TRANSACTIONS(status)
