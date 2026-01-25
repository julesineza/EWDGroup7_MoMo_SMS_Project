## EWDGroup7_MoMo_SMS_Project

# MoMo SMS Analytics Dashboard

## Team Name
MoMo Insights Team

## Team Members
- Ineza Jules – [j.ineza@alustudent.com](mailto:julesineza@alustudent.com)
- Charles Were Angoye – [c.angoye@alustudent.com](mailto:c.angoye@alustudent.com)
- Nyiramanzi Igihozo– [n.igihozo@alustudent.com](mailto:n.igihozo@alustudent.com)
- Nawaf Awadallah Ahmed – [n.ahmed@alustudent.com](mailto:n.ahmed@alustudent.com)
- Esther Mahoro – [e.mahoro@alustudent.com](mailto:e.mahoro@alustudent.com)

## Project Description
This project processes MoMo SMS messages provided in XML format, cleans and categorizes the transactions, stores them in a relational database, and visualizes insights using a frontend dashboard.

The system follows an ETL pipeline:
- Extract SMS data from XML
- Transform and normalize transactions data
- Load cleaned data into a relational database 
- Generate analytics for frontend visualization


## High-Level Architecture
Architecture Diagram:
[![Miro](https://img.shields.io/badge/Miro-Architecture%20Diagram-yellow?style=for-the-badge&logo=miro)](https://miro.com/welcomeonboard/NHFOQzBGcjJuZ0RqQUtxNW9CR0FvaFZ6ejZ5LzNmNk5QUTYrMWE3L09hMko4WVdTZ1JIK2x3czZwM1dINkVTUkhmRFNYVW43aFhvNW1ZWGQ4V1JvT1ZSVXpPRkJSWUNIVE9weUtiVzVReEJsVk1HZDY1THdoeUdxK2hnLytWemxQdGo1ZEV3bUdPQWRZUHQzSGl6V2NBPT0hdjE=?share_link_id=242889040250)

## Scrum Board
Trello Project Board:
[![Trello](https://img.shields.io/badge/Trello-Scrum%20Board-blue?style=for-the-badge&logo=trello)](https://trello.com/invite/b/6962965c59508e6196870656/ATTI01572b19ae2292c8ecaaa91d9f80b5d6A494334E/ewdgroup7momosmsproject)


# MoMo SMS Database Design Explanation

This document explains the structure and reasoning behind the **MoMo SMS database**, which stores and manages data parsed from the modified_sms_v2.xml file.

---

## Database Architecture

**Database Name:** Momo  
**Database Type:** Relational Database  
**Total Number of Tables:** 5  

The database is designed to efficiently store, relate, and analyze Mobile Money (MoMo) SMS transaction data while maintaining data integrity and scalability.

---

## Tables Overview

### 1. USERS

The USERS table stores information about all MoMo customers.

**Attributes:**
user_id (Primary Key)  
full_name  
phone_number (Unique for every user)  
reg_date  
last_transaction  
created_at (Timestamp indicating when the user record was created)

Each user is uniquely identified by user_id.

---

### 2. TRANSACTIONS

The TRANSACTIONS table is the core table of the database. It stores all transaction records, whether money is sent, received, withdrawn, or deposited.

**Attributes:**
transaction_id (Primary Key)  
sender_id (Foreign Key → USERS.user_id)  
receiver_id (Foreign Key → USERS.user_id)  
category_id (Foreign Key → TRANSACTION_CATEGORY.category_id)  
amount (Must be positive)  
balance_before  
balance_after  
trans_date  
status (Completed, Pending, Failed, Reversed)  
message (Promotional or warning messages related to the transaction)  
created_at (Datetime indicating when the transaction was created)

---

### 3. TRANSACTION_CATEGORY

The TRANSACTION_CATEGORY table defines the different types of transactions supported by the system.

**Attributes:**
category_id (Primary Key)  
category_name  
category_type (e.g., Send, Payment, Withdrawal, Deposit, Received)  
description  
created_at (Datetime indicating when the category was created)

This table helps standardize transaction classification.

---

### 4. SYSTEM_LOGS

The SYSTEM_LOGS table tracks system-level events and actions, which helps with monitoring and debugging.

**Attributes:**
log_id (Primary Key)  
log_type (INFO, WARNING, ERROR, DEBUG)  
message  
created_at (Datetime)  
user_id (Foreign Key → USERS.user_id)  
transaction_id (Foreign Key → TRANSACTIONS.transaction_id)

This table makes it easier to trace issues related to users or transactions.

---

### 5. TRANSACTION_SYSTEM_LOG

The TRANSACTION_SYSTEM_LOG table is a **junction table** that links transactions and system logs.

It supports a **many-to-many relationship** between TRANSACTIONS and SYSTEM_LOGS.
A single transaction can have multiple logs.
A single log can be associated with multiple transactions.

---

## Design Reasoning

Users and transactions are separated to avoid data duplication and to keep user-specific data (such as phone number and registration date) independent from transactional data.
The database has **two core tables**:
  - USERS
  - TRANSACTIONS
Three **supporting tables** enhance structure and maintainability:
  - TRANSACTION_CATEGORY
  - SYSTEM_LOGS
  - TRANSACTION_SYSTEM_LOG
Foreign keys are used extensively to:
  - Link transactions to users
  - Associate transactions with categories
  - Connect logs to transactions and users
Junction tables are used where **many-to-many cardinality** exists, ensuring the design remains normalized and scalable.

---

## Summary

This relational design ensures:
Data integrity through foreign keys  
Clear separation of concerns  
Easier debugging and auditing  
Scalability for future features and analytics  

The schema provides a solid foundation for processing, querying, and analyzing MoMo SMS transaction data.
