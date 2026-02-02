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

# Team participation sheet

https://docs.google.com/spreadsheets/d/16CogD206nQywE-DSJM5fJfIYAEJY_wS3HNVKH_5iqK4/edit?usp=sharing

# Design Rationale and Justification

The source dataset consists of SMS messages from a mobile money service; however, not every SMS represents a valid financial transaction. For this reason, all incoming SMS records are first stored in a system_logs table, which preserves the raw message body and metadata exactly as received. This approach allows traceability, reprocessing, and verification of parsed transactions.
Financial transactions are stored in a dedicated transactions table and are created only after successfully extracting structured information (such as transaction ID, amount, and timestamp) from the SMS content. Linking transactions back to system logs ensures data integrity and supports auditing requirements.
Users are modeled separately to avoid data duplication and to support reuse across multiple transactions. Since a transaction can involve multiple users playing different roles (e.g., sender, receiver, agent), a transaction_participants table is used to resolve the many-to-many relationship between users and transactions while explicitly storing participant roles. This design is more flexible than hard-coding sender and receiver fields and supports future extensions.
Transaction classification is handled using a normalized transaction_categories table combined with a junction table (transaction_category_map) to model a many-to-many relationship. This allows a single transaction to belong to multiple analytical categories without violating normalization rules

# MoMo SMS Transaction REST API

A secure REST API for managing Mobile Money (MoMo) SMS transaction records, built with Python's `http.server` module.

## Project Structure

```
momo-sms-api/
├── api/
│   └── app.py              # REST API implementation with Basic Auth
|   └── authentication.py   #security and authentication
├── dsa/
│   ├── xml_parser.py          # XML to JSON parsing module
│   └── search_comparison.py   # Linear search vs Dictionary lookup comparison
|   └── modified_sms_v2.xml
├── docs/
│   └── api_docs.md            # API endpoint documentation
├── screenshots/
│   └── (test case screenshots)
├── README.md                  # This file
└── requirements.txt           # Python dependencies
```

## Prerequisites

- Python 3.8 or higher
- `curl` or Postman for API testing
- Git (for cloning the repository)

## Installation & Setup

### 1. Clone the Repository

```bash
git clone https://github.com/julesineza/EWDGroup7_MoMo_SMS_Project.git

```

### 2. Create a Virtual Environment (Recommended)

```bash
# Create virtual environment
python3 -m venv venv

# Activate virtual environment
# On Linux/macOS:
source venv/bin/activate

# On Windows:
venv\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

> **Note:** This project uses Python's built-in flask module, so external dependencies are minimal.

## Running the API Server

### Start the Server

```bash
python api/app.py
```

### Default Credentials

The API uses Basic Authentication with the following default credentials:

- **Username:** `admin`
- **Password:** `admin123`

## API Endpoints

| Method | Endpoint             | Description                      |
| ------ | -------------------- | -------------------------------- |
| GET    | `/transactions`      | List all SMS transactions        |
| GET    | `/transactions/{id}` | Get a specific transaction by ID |
| POST   | `/transactions`      | Create a new transaction         |
| PUT    | `/transactions/{id}` | Update an existing transaction   |
| DELETE | `/transactions/{id}` | Delete a transaction             |

## Testing the API

### Using curl

#### 1. List All Transactions (with authentication)

```bash
curl -u admin:password123 http://localhost:8000/transactions
```

#### 2. Get a Specific Transaction

```bash
curl -u admin:password123 http://localhost:8000/transactions/1
```

#### 3. Create a New Transaction

```bash
curl -u admin:password123 \
  -X POST \
  -H "Content-Type: application/json" \
  -d '{  <sms protocol="0" address="M-Money" date="1726062245327" type="1" subject="null" body="Yello!Umaze kugura 3000Frw=2500Mins+100SMS igura 3,000 RWF" toa="null" sc_toa="null" service_center="+250788110383" read="1" status="-1" locked="0" date_sent="1726062234000" sub_id="6" readable_date="11 Sep 2024 3:44:05 PM" contact_name="(Unknown)" />
}' \
  http://localhost:8000/transactions
```

#### 4. Update a Transaction

```bash
curl -u admin:password123 \
  -X PUT \
  -H "Content-Type: application/json" \
  -d '{"amount": 7500}' \
  http://localhost:8000/transactions/1
```

#### 5. Delete a Transaction

```bash
curl -u admin:password123 \
  -X DELETE \
  http://localhost:8000/transactions/1
```

#### 6. Test Unauthorized Access

```bash
curl -u wronguser:wrongpass http://localhost:8000/transactions
# Expected: 401 Unauthorized
```
