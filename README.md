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


# Design Rationale and Justification

The source dataset consists of SMS messages from a mobile money service; however, not every SMS represents a valid financial transaction. For this reason, all incoming SMS records are first stored in a system_logs table, which preserves the raw message body and metadata exactly as received. This approach allows traceability, reprocessing, and verification of parsed transactions.
Financial transactions are stored in a dedicated transactions table and are created only after successfully extracting structured information (such as transaction ID, amount, and timestamp) from the SMS content. Linking transactions back to system logs ensures data integrity and supports auditing requirements.
Users are modeled separately to avoid data duplication and to support reuse across multiple transactions. Since a transaction can involve multiple users playing different roles (e.g., sender, receiver, agent), a transaction_participants table is used to resolve the many-to-many relationship between users and transactions while explicitly storing participant roles. This design is more flexible than hard-coding sender and receiver fields and supports future extensions.
Transaction classification is handled using a normalized transaction_categories table combined with a junction table (transaction_category_map) to model a many-to-many relationship. This allows a single transaction to belong to multiple analytical categories without violating normalization rules
