-- Creating databases for project.

create database MoMo;

-- Use that database for creating tables

use MoMo;

-- First we gonna create table for storing user's data (Is the main one)

create table USERS (
    user_id VARCHAR(20) PRIMARY KEY COMMENT 'Unique identifier  for each user, typically UUID string',
    full_name VARCHAR(100) NOT NULL COMMENT 'The legal names of the account holder',
    phone_number VARCHAR(30) NOT NULL UNIQUE COMMENT 'Unique phone number of the user',
    reg_date DATETIME,
    last_transaction DATETIME COMMENT 'This is the date and time of the last transaction has been occured',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP COMMENT 'This is when the transaction has been occured'
);

-- Records for the Users table

insert into USERS (user_id, full_name, phone_number, reg_date, last_transaction) VALUES
('u_01', 'Eddy BYIRINGIRO', '+250788381001', '2025-01-01 00:00:00' '2025-12-31 11:59:00'),
('u_02', 'Celine IRAKOZE', '+250788392002', '2025-03-15 09:36:35' '2025-11-28 13:41:30'),
('u_03', 'Jane GASINGE', '+250788403003', '2025-07-21 10:40:49' '2025-12-27 08:17:43'),
('u_04', 'Kellia INEZA', '+250788414004', '2025-08-08 11:55:28' '2025-12-02 15:22:37'),
('u_01', 'Angel MUGISHA', '+250788425005', '2025-05-25 12:18:47' '2026-01-22 17:30:19');

