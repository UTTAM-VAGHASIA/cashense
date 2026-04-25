# Cashense — Firestore Schema

> Reference for all Firestore collections and document structures.

---

## Top-Level Collections

```
users/
groups/
workspaces/
```

---

## users/{userId}/

### accounts/{accountId}
```json
{
  "id": "string",
  "name": "HDFC Savings",
  "type": "bank | cash | upi_wallet | credit_card",
  "balance": 25000.00,
  "currency": "INR",
  "color": "#4CAF50",
  "icon": "bank",
  "isDefault": true,
  "createdAt": "timestamp",
  "updatedAt": "timestamp"
}
```

### transactions/{transactionId}
```json
{
  "id": "string",
  "type": "expense | income | transfer",
  "amount": 350.00,
  "category": "food",
  "accountId": "string",
  "toAccountId": "string | null",
  "date": "timestamp",
  "note": "Lunch at office",
  "tags": ["work", "lunch"],
  "receiptUrl": "string | null",
  "isRecurring": false,
  "recurringInterval": "monthly | weekly | yearly | null",
  "groupExpenseId": "string | null",
  "workspaceId": "string | null",
  "createdAt": "timestamp"
}
```

### budgets/{budgetId}
```json
{
  "id": "string",
  "category": "food",
  "amount": 5000.00,
  "period": "monthly",
  "month": 4,
  "year": 2026,
  "spent": 3200.00,
  "alertAt80": true,
  "alertAt100": true,
  "carryForward": false,
  "createdAt": "timestamp"
}
```

### bills/{billId}
```json
{
  "id": "string",
  "name": "Netflix",
  "type": "subscription | rent | emi | utility | insurance | custom",
  "amount": 649.00,
  "dueDay": 15,
  "isRecurring": true,
  "lastPaidDate": "timestamp | null",
  "nextDueDate": "timestamp",
  "status": "pending | paid | overdue",
  "accountId": "string | null",
  "remindDaysBefore": [7, 1],
  "createdAt": "timestamp"
}
```

### goals/{goalId}
```json
{
  "id": "string",
  "name": "Emergency Fund",
  "targetAmount": 200000.00,
  "currentAmount": 85000.00,
  "deadline": "timestamp",
  "linkedAccountId": "string | null",
  "icon": "umbrella",
  "color": "#2196F3",
  "createdAt": "timestamp"
}
```

### assets/fds/{fdId}
```json
{
  "id": "string",
  "bank": "HDFC Bank",
  "principal": 100000.00,
  "interestRate": 7.1,
  "compounding": "quarterly",
  "startDate": "timestamp",
  "maturityDate": "timestamp",
  "maturityAmount": 107100.00,
  "isAutoRenew": false,
  "accountNumber": "XXXX1234",
  "createdAt": "timestamp"
}
```

### assets/stocks/{stockId}
```json
{
  "id": "string",
  "exchange": "NSE",
  "symbol": "RELIANCE",
  "quantity": 10,
  "buyPrice": 2450.00,
  "buyDate": "timestamp",
  "currentPrice": 2780.00,
  "lastPriceUpdate": "timestamp",
  "broker": "Zerodha",
  "createdAt": "timestamp"
}
```

### assets/mutual_funds/{mfId}
```json
{
  "id": "string",
  "schemeName": "Mirae Asset Large Cap Fund",
  "schemeCode": "118989",
  "units": 250.5,
  "buyNav": 85.20,
  "buyDate": "timestamp",
  "currentNav": 102.40,
  "lastNavUpdate": "timestamp",
  "folio": "string",
  "broker": "Groww",
  "isElss": false,
  "createdAt": "timestamp"
}
```

### assets/gold/{goldId}
```json
{
  "id": "string",
  "type": "physical | digital | sgb",
  "grams": 50.0,
  "buyPricePerGram": 5800.00,
  "buyDate": "timestamp",
  "currentPricePerGram": 7200.00,
  "lastPriceUpdate": "timestamp",
  "description": "22K jewellery",
  "createdAt": "timestamp"
}
```

### assets/property/{propertyId}
```json
{
  "id": "string",
  "name": "Flat in Powai",
  "address": "string",
  "purchaseValue": 8500000.00,
  "purchaseDate": "timestamp",
  "estimatedCurrentValue": 11000000.00,
  "lastUpdated": "timestamp",
  "type": "residential | commercial | land | other",
  "createdAt": "timestamp"
}
```

### assets/other/{assetId}
```json
{
  "id": "string",
  "name": "PPF Account",
  "type": "ppf | epf | nps | vehicle | other",
  "currentValue": 450000.00,
  "lastUpdated": "timestamp",
  "notes": "string",
  "createdAt": "timestamp"
}
```

### liabilities/loans/{loanId}
```json
{
  "id": "string",
  "type": "home | car | personal | education | other",
  "bank": "SBI",
  "originalAmount": 3000000.00,
  "interestRate": 8.5,
  "tenureMonths": 240,
  "startDate": "timestamp",
  "emiAmount": 26035.00,
  "emiDay": 5,
  "remainingPrincipal": 2750000.00,
  "accountNumber": "XXXX5678",
  "createdAt": "timestamp"
}
```

### liabilities/credit_cards/{cardId}
```json
{
  "id": "string",
  "bank": "HDFC",
  "cardName": "Regalia",
  "last4Digits": "4321",
  "creditLimit": 200000.00,
  "outstandingBalance": 45000.00,
  "minimumDue": 2250.00,
  "billingDate": 15,
  "dueDate": 5,
  "createdAt": "timestamp"
}
```

### insurance/{policyId}
```json
{
  "id": "string",
  "type": "term | health | vehicle | home | custom",
  "insurer": "LIC of India",
  "policyName": "Tech Term",
  "policyNumber": "123456789",
  "sumAssured": 10000000.00,
  "annualPremium": 15000.00,
  "premiumDueDate": "timestamp",
  "expiryDate": "timestamp",
  "nominee": "Spouse Name",
  "notes": "string",
  "createdAt": "timestamp"
}
```

---

## groups/{groupId}/

### Group Document
```json
{
  "id": "string",
  "name": "Goa Trip 2026",
  "type": "trip | roommates | couple | event | other",
  "members": ["uid1", "uid2", "uid3"],
  "memberNames": {"uid1": "Yaksi", "uid2": "Raj"},
  "createdBy": "uid1",
  "createdAt": "timestamp",
  "isSettled": false
}
```

### expenses/{expenseId}
```json
{
  "id": "string",
  "description": "Hotel booking",
  "amount": 9000.00,
  "paidBy": "uid1",
  "splitType": "equal | percentage | exact | shares",
  "splits": {
    "uid1": 3000.00,
    "uid2": 3000.00,
    "uid3": 3000.00
  },
  "date": "timestamp",
  "category": "travel",
  "createdAt": "timestamp"
}
```

### balances/{uid}
```json
{
  "uid": "string",
  "owes": {
    "uid2": 1500.00
  },
  "isOwed": {
    "uid3": 2000.00
  },
  "lastUpdated": "timestamp"
}
```

---

## workspaces/{workspaceId}/

### Workspace Document
```json
{
  "id": "string",
  "name": "Family Finance",
  "ownerId": "uid1",
  "memberIds": ["uid1", "uid2"],
  "memberRoles": {
    "uid1": "admin",
    "uid2": "editor"
  },
  "createdAt": "timestamp"
}
```
