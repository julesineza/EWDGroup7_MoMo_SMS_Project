## EWDGroup7_MoMo_SMS_Project

# MoMo SMS Analytics Dashboard

## Team Name
MoMo Insights Team

## Team Members
- Ineza Jules – [julesineza@alustudent.com](mailto:julesineza@alustudent.com)
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

MoMo SMS Database Design Explanation

In our database, we have five tables that work cooperatively to manage data parsed from the modified_sms_v2.xml file. 

Database Architecture :
Database name : Momo
Total number of Tables : 5 
Database type : Relational database 

The USERS table   has the following attributes : 
user_id (primary key)
full_name ,
phone_number (unique for every user),
reg_date, 
last_transaction for every customer with a unique id represented as user_id.
created_at : this is a timestamp of the time and date of when the entry of the user has been created . 

The TRANSACTIONS entity , is the most important table here  which contains all the entries related to the transfers made by the user or to the user , like 
Transaction_id (primary key) , 
Sender_id (foreign key from USERS)
receiver_id (foreign key from USERS)
Category_id (foreign key from the TRANSACTION_CATEGORY)
amount  , that needs to be positive , you can not send negative money 
balance_before , 
balance_after, 
trans_date, 
status  , like Completed or Pending or Failed or Reversed,
messages , messages that come with the transaction promotional or warnings
created at : datetime which stores the time and date the transaction has been made
The TRANSACTION_CATEGORY table stores the various transaction categories, using column fields like : 
Category_id (primary key ),
category_name, 
category_type, which also includes categories like Send, Payment, Withdrawal, Deposit, Received, 
description. 
Created_at : datetime which stores the time and time the transaction category has been made 

The SYSTEM_LOGS table tracks what happens in the system with : 
Log_id (primary key)
log_type (e.g., INFO/WARNING/ERROR/DEBUG), 
message, 
Created_at : datetime .
user_id (foreign key from USERS table)
transaction_id  (foreign key from TRANSACTIONS table)

This table  helps in debugging the system faster.

The TRANSACTION_SYSTEM_LOG is a junction table  used to relate the transaction with the log , the table has a many to many relationship between transactions and logs and so is used as a junction table . 

Reasoning

We separated transactions from users because users have a lot of important information like phone number , registration date to say a few . We hence have two main tables for tracking momo transactions (users and transactions ) and 3 tables (transactions_category , system_logs and transaction_system_log) which support the transactions . We connect the data using foreign keys between tables to connect transactions to users , logs to transactions , transaction to categories and we furthermore use junction tables to handle many to many cardinality relationships .

