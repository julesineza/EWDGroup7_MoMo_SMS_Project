# MoMo SMS Transaction API Documentation

## Authentication
All endpoints (except the home route) require Basic Authentication.
- Type: Basic Auth
- Credentials: Defined in `etl/authentication.py` (Default: `admin` / `secret`)

---

## 1. Get All Transactions
Retrieves a list of all parsed SMS transactions.

**Endpoint & Method**
`GET /transactions`

**Request Example**
```bash
curl -u admin:secret http://127.0.0.1:5000/transactions
```
## Response example
{
    "id": "Pay1675",
    "sms": {
      "address": "M-Money",
      "body": "TxId: 31581671113. Your payment of 10,000 RWF to Jane Smith 97571 has been completed at 2025-01-13 14:22:39. Your new balance: 22,773 RWF. Fee was 0 RWF.",
      "contact_name": "(Unknown)",
      "date": "1736770965767",
      "date_sent": "1736770959000",
      "locked": "0",
      "protocol": "0",
      "read": "1",
      "readable_date": "13 Jan 2025 2:22:45 PM",
      "sc_toa": "null",
      "service_center": "+250788110383",
      "status": "-1",
      "sub_id": "6",
      "subject": "null",
      "toa": "null",
      "type": "1"
    }
}

###Error code
   401 unauthorized: credentials missing or invalid

## 2. Get single transactions
Retrieves details for a specific transaction using it's ID

### End points and method
GET /transactions/{id}
### Request example
GET /transactions/Pay1691

### Response example:

{
  "id": "Pay1691",
  "sms": {
    "address": "M-Money",
    "body": "TxId: 37832903831. Your payment of 24,900 RWF to Robert Brown 23478 has been completed at 2025-01-16 00:13:22. Your new balance: 4,900 RWF. Fee was 0 RWF.",
    "contact_name": "(Unknown)",
    "date": "1736979209935",
    "date_sent": "1736979202000",
    "locked": "0",
    "protocol": "0",
    "read": "1",
    "readable_date": "16 Jan 2025 12:13:29 AM",
    "sc_toa": "null",
    "service_center": "+250788110383",
    "status": "-1",
    "sub_id": "6",
    "subject": "null",
    "toa": "null",
    "type": "1"
  }
}

### Error codes
404 Not found: Id not found

## 3. Create Transaction
Adds a new transaction record. the Id is auto generated based on keywords in the body feild.

### Endpoints and meethods

POST /transactions/

### Request Example

curl -u admin:admin123 -X POST http://127.0.0.1:5000/transactions/ \
     -H "Content-Type: application/json" \
     -d '{"body": "payment of 5000 to John", "address": "M-Money", "readable_date": "20 Oct 2025"}'

### Response Exaple

{
  "id": "Pay1694",
  "sms": {
    "address": "M-Money",
    "body": "payment of 5000 to John",
    "readable_date": "20 Oct 2025"
  }
}

### Error codees
400 Bad request: Request body is not valid JSON.


## 4. Update Transaction
Updates the sms details of an existing record.

### Endpoints and method
PUT /transaction/{id}

### Request example 

curl -u admin:admin123 -X PUT http://127.0.0.1:5000/transactions/Pay1694 \
     -H "Content-Type: application/json" \
     -d '{"body": "UPDATED payment description"}'

### Response example 
{
  "id": "Pay1694",
  "sms": {
    "address": "M-Money",
    "body": "UPDATED payment description",
    "readable_date": "20 Oct 2025"
  }
}

## 5. Delete Transaction
Removes a transaction record.

### Endpoint and method
Delete /transaction/{id}

### Request example 
curl -u admin:admin123 -X DELETE http://127.0.0.1:5000/transactions/Pay1694

### Respond example 
{
  "success": "Pay1694 removed successfully"
}

### Error codes
 404 Not found: The record ID dose not exist.