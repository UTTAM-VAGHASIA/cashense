# Cashense — Master Plan

> **Version:** 1.0 | **Last Updated:** April 15, 2026
> 
> This is the phase-wise execution plan. Update status as phases complete.

---

## Phase Overview

```
+============================================================+
|              CASHENSE DEVELOPMENT PHASES                   |
+============================================================+
|                                                            |
| PHASE 0: FOUNDATION FIXES (Week 1)                        |
| [=] iOS auth, routing, core models                        |
|                                                            |
| PHASE 1: CORE FINANCE (Weeks 2–7)                        |
|     [=] Expenses, Accounts, Budgets, Bills               |
|                                                            |
| PHASE 2: SOCIAL FINANCE (Weeks 8–11)                     |
|         [=] Groups, Splitwise debts                      |
|                                                            |
| PHASE 3: WEALTH TRACKER (Weeks 12–17)                    |
|                 [=] Assets, Liabilities, Net Worth       |
|                                                            |
| PHASE 4: PROTECT (Weeks 18–21)                           |
|                         [=] Insurance, Tax               |
|                                                            |
| PHASE 5: INTELLIGENCE (Weeks 22–27)                      |
|                                 [=] AI, SMS, Analytics   |
|                                                            |
| PHASE 6: SCALE (Weeks 28–36)                             |
|                                         [=] Family, Tax  |
+============================================================+
```

---

## Phase Status

| Phase | Name | Status |
|-------|------|--------|
| 0 | Foundation Fixes | In progress (0.2 ✅, 0.3 ✅, 0.1 ⏳ awaiting iOS client IDs) |
| 1 | Core Finance | Pending |
| 2 | Social Finance | Pending |
| 3 | Wealth Tracker | Pending |
| 4 | Protect | Pending |
| 5 | Intelligence | Pending |
| 6 | Scale | Pending |

---

## PHASE 0 — Foundation Fixes

> **Goal:** Unblock all future development. Nothing else can be built without routing and models.

### 0.1 — iOS Google Sign-In

**Files to update (1 file):**
- `lib/flavors/flavor_constants.dart` — Fill 3 TODOs with iOS CLIENT_ID and REVERSED_CLIENT_ID

**How to get iOS client ID:**
1. Go to Google Cloud Console → APIs & Credentials
2. Find the iOS OAuth client for `cashense-dev`, `cashense-staging`, `cashense`
3. Copy CLIENT_ID and com.googleusercontent.apps.xxx as REVERSED_CLIENT_ID

**Test:** Run on iOS simulator → tap Google Sign-In → should authenticate

---

### 0.2 — App Navigation & Routing

**Files to create:**
```
lib/routes/routes.dart                  # Named route constants
lib/routes/app_route_pages.dart         # GoRouter configuration
lib/routes/routes_middleware.dart       # Auth guard middleware
lib/routes/routes_observer.dart         # Navigation observer
```

**Route structure:**
```dart
/splash
/welcome
/login
/home
/transactions
/accounts
/budgets
/bills
/groups
/group/:id
/assets
/liabilities
/insurance
/net-worth
/goals
/analytics
/ai-chat
/profile
/settings
```

**Test:** `flutter analyze` → 0 errors. Navigate between splash → login → home.

---

### 0.3 — Core Data Models

**Files to create:**
```
lib/data/models/transaction_model.dart
lib/data/models/account_model.dart
lib/data/models/budget_model.dart
lib/data/models/saving_goal_model.dart
lib/data/models/group_model.dart
lib/data/models/group_expense_model.dart
lib/data/models/debt_model.dart
lib/data/models/bill_model.dart
lib/data/models/subscription_model.dart
```

**Each model needs:** `toJson()`, `fromJson()`, `fromFirestore()`, `copyWith()`

**Test:** Unit test each model's serialization round-trip.

---

## PHASE 1 — Core Finance

> **Goal:** User can log transactions, manage accounts, set budgets, track bills.
> **Deliverable:** Functional personal finance tracker.

### 1.1 — Home Dashboard

**Files to create:**
```
lib/features/home/
├── bindings/home_binding.dart
├── controllers/home_controller.dart
├── views/home_screen.dart
└── widgets/
    ├── balance_card.dart           # Total balance across accounts
    ├── recent_transactions.dart    # Last 5 transactions
    ├── budget_summary_card.dart    # Over/under budget indicator
    └── quick_add_fab.dart          # Floating add button
```

**UI elements:**
- Top: greeting + profile avatar
- Balance card: total balance, income this month, expenses this month
- Recent transactions list (last 5)
- Budget status strip (% used per top category)
- FAB: quick-add transaction (bottom sheet)

---

### 1.2 — Expense Tracking

**Files to create:**
```
lib/features/transactions/
├── bindings/transactions_binding.dart
├── controllers/transactions_controller.dart
├── views/
│   ├── transactions_screen.dart    # Full list with filter/search
│   └── add_transaction_screen.dart # Add/edit form
└── widgets/
    ├── transaction_tile.dart
    ├── category_picker.dart        # 30+ categories with icons
    ├── account_selector.dart
    └── transaction_filter_bar.dart
```

**Features:**
- Add income/expense/transfer
- Categories: Food, Transport, Health, Shopping, Entertainment, Rent, EMI, Salary, Freelance, Investment, Other (+ custom)
- Account picker (from accounts list)
- Date picker, note field, receipt photo (optional)
- Recurring transaction toggle
- Edit and delete with confirmation

---

### 1.3 — Account Management

**Files to create:**
```
lib/features/accounts/
├── bindings/accounts_binding.dart
├── controllers/accounts_controller.dart
├── views/
│   ├── accounts_screen.dart
│   └── add_account_screen.dart
└── widgets/
    ├── account_card.dart
    └── account_type_picker.dart
```

**Account types:** Cash, Bank Account, UPI Wallet (Paytm, PhonePe, GPay), Credit Card

**Features:**
- Create/edit/delete accounts
- Per-account balance (auto-calculated from transactions)
- Transfer between accounts (creates two transactions, no double-count)
- Running balance timeline

---

### 1.4 — Budget System

**Files to create:**
```
lib/features/budgets/
├── bindings/budgets_binding.dart
├── controllers/budgets_controller.dart
├── views/
│   ├── budgets_screen.dart
│   └── add_budget_screen.dart
└── widgets/
    ├── budget_progress_card.dart   # Progress bar green/yellow/red
    └── budget_vs_actual_chart.dart
```

**Features:**
- Set monthly budget per category (e.g., Food ₹5,000/month)
- Auto-compare with actual spending from transactions
- Color-coded alerts: green (<80%), yellow (80–100%), red (>100%)
- Push notification when 80% and 100% reached
- Budget carry-forward option

---

### 1.5 — Bill Payment Reminders

**Files to create:**
```
lib/features/bills/
├── bindings/bills_binding.dart
├── controllers/bills_controller.dart
├── views/
│   ├── bills_screen.dart
│   └── add_bill_screen.dart
└── widgets/
    ├── bill_tile.dart              # Shows name, amount, due date, status
    └── upcoming_bills_strip.dart   # Next 7 days bills on home
```

**Reminder tiers:** 7 days before → 1 day before → Day of (push notifications via FCM)

**Bill types:** Rent, Home Loan EMI, Car Loan EMI, Electricity, Internet, Mobile, OTT, Insurance premium, Credit Card due, Custom

**Packages to add:** `flutter_local_notifications`, `firebase_messaging`

---

### Phase 1 — Test Checklist

```
[ ] flutter analyze → 0 errors
[ ] Add a transaction → appears in home recent list
[ ] Budget 80% → push notification fires
[ ] Bill due in 1 day → push notification fires
[ ] Transfer between accounts → both balances update, no duplicate in net
[ ] Recurring transaction → auto-creates next month entry
```

---

## PHASE 2 — Social Finance

> **Goal:** Splitwise-style group expenses and debt settlement.
> **Deliverable:** Users can split bills with friends and settle up.

### 2.1 — Group Expenses

**Files to create:**
```
lib/features/groups/
├── bindings/groups_binding.dart
├── controllers/groups_controller.dart
├── views/
│   ├── groups_screen.dart          # All groups list
│   ├── group_detail_screen.dart    # Single group: expenses + balances
│   └── add_group_expense_screen.dart
└── widgets/
    ├── group_card.dart
    ├── expense_split_card.dart     # Who owes whom
    ├── split_calculator.dart       # Equal / % / custom split
    └── settle_up_sheet.dart        # Mark as settled bottom sheet
```

**Split modes:** Equal split, percentage split, exact amounts, by shares

**Debt simplification algorithm:**
- Reduce number of transactions needed to settle all balances
- Example: A owes B ₹100, B owes C ₹100 → simplified to A pays C ₹100

**Firestore structure:**
```
groups/{groupId}/
  members: [uid, ...]
  expenses/{expenseId}/
    amount, paid_by, splits: {uid: amount}, date, note
  balances/{uid}/
    owes: {uid: amount}
```

---

### 2.2 — Debt Settlement

**Features:**
- "Settle up" screen showing minimum transactions to clear all debts
- Record settlement: mark debt as paid (creates a transaction)
- UPI deep link: `upi://pay?pa=...` to open payment app
- Settlement history

---

### Phase 2 — Test Checklist

```
[ ] Create group with 3 members
[ ] Add expense of ₹300 split equally → each owes ₹100
[ ] Debt simplification: A→B ₹100, B→C ₹100 → shows A→C ₹100
[ ] Settle up flow → debt removed
[ ] UPI deep link opens payment app
```

---

## PHASE 3 — Wealth Tracker

> **Goal:** User sees all assets, liabilities, and live net worth.
> **Deliverable:** Complete balance sheet in one screen.

### 3.1 — Assets Tracker

**Files to create:**
```
lib/features/assets/
├── bindings/assets_binding.dart
├── controllers/assets_controller.dart
├── views/
│   ├── assets_screen.dart          # All assets grouped by type
│   ├── add_fd_screen.dart
│   ├── add_stock_screen.dart
│   ├── add_mf_screen.dart
│   ├── add_gold_screen.dart
│   ├── add_property_screen.dart
│   └── add_other_asset_screen.dart
└── widgets/
    ├── asset_category_section.dart
    ├── fd_card.dart
    ├── stock_card.dart             # Shows P&L with color
    └── asset_summary_bar.dart
```

**Asset types and fields:**

| Type | Fields |
|------|--------|
| Fixed Deposit | Bank, principal, interest rate %, start date, maturity date, compounding |
| Stocks | Exchange (NSE/BSE), symbol, qty, buy price, buy date |
| Mutual Fund | Scheme name, units, buy NAV, buy date |
| Gold | Type (physical/digital/SGB), grams, buy price/gram, buy date |
| Real Estate | Property name/address, purchase value, purchase date, estimated current value |
| PPF/EPF/NPS | Account no., balance, last updated date |
| Other | Name, current value, notes |

**Live price fetch (Stocks/MF):**
- NSE India unofficial API or Yahoo Finance for stock prices
- AMFI NAV API for mutual fund NAVs (free, official)
- Gold price: MCX via public API

---

### 3.2 — Liabilities Tracker

**Files to create:**
```
lib/features/liabilities/
├── bindings/liabilities_binding.dart
├── controllers/liabilities_controller.dart
├── views/
│   ├── liabilities_screen.dart
│   ├── add_loan_screen.dart
│   └── add_credit_card_screen.dart
└── widgets/
    ├── loan_card.dart              # Shows remaining principal, EMI
    ├── credit_card_card.dart       # Outstanding, limit, billing date
    └── emi_schedule_sheet.dart     # Full EMI schedule bottom sheet
```

**Liability types:**

| Type | Fields |
|------|--------|
| Home Loan | Bank, original amount, interest rate, tenure, start date, EMI amount |
| Car Loan | Same as above |
| Personal Loan | Same as above |
| Education Loan | Same as above |
| Credit Card | Bank, credit limit, outstanding balance, billing date, min due |
| Informal Debt | Person name, amount, due date, note |

**Auto-calculation:** Remaining principal from EMI schedule formula

---

### 3.3 — Net Worth Dashboard

**Files to create:**
```
lib/features/net_worth/
├── controllers/net_worth_controller.dart
├── views/net_worth_screen.dart
└── widgets/
    ├── net_worth_header.dart       # Big number + change from last month
    ├── net_worth_trend_chart.dart  # Monthly line chart (fl_chart)
    ├── asset_breakdown_pie.dart    # By asset class
    └── milestone_banner.dart      # "You hit ₹10L!" celebration
```

**Net Worth = Sum(all assets current value) − Sum(all liabilities remaining balance)**

**Milestones:** ₹1L, ₹5L, ₹10L, ₹25L, ₹50L, ₹1Cr

**Packages to add:** `fl_chart`, `confetti`

---

### 3.4 — Saving Goals

**Files to create:**
```
lib/features/goals/
├── controllers/goals_controller.dart
├── views/
│   ├── goals_screen.dart
│   └── add_goal_screen.dart
└── widgets/
    ├── goal_progress_card.dart
    └── goal_contribution_chart.dart
```

**Fields:** Name, target amount, deadline, linked account, icon, current balance

**AI suggestion:** "To reach ₹2L by Dec 2026, save ₹8,500/month"

---

### Phase 3 — Test Checklist

```
[ ] Add FD → appears in assets, total assets updates
[ ] Add stock → live price fetched, P&L calculated
[ ] Add home loan → net worth decreases
[ ] Net worth = assets - liabilities (verify math)
[ ] Monthly trend chart shows data after 2 months
[ ] Goal 50% complete → progress bar shows 50%
```

---

## PHASE 4 — Protect

> **Goal:** Store all insurance policies and track tax-saving investments.
> **Deliverable:** User never misses a premium renewal or tax deadline.

### 4.1 — Insurance Vault

**Files to create:**
```
lib/features/insurance/
├── controllers/insurance_controller.dart
├── views/
│   ├── insurance_screen.dart
│   └── add_insurance_screen.dart
└── widgets/
    ├── policy_card.dart
    └── renewal_countdown.dart      # "Renews in 12 days"
```

**Policy types:**

| Type | Fields |
|------|--------|
| Term Life | Insurer, sum assured, annual premium, premium due date, nominee |
| Health | Insurer, coverage amount, members covered, cashless hospitals (free text), expiry date |
| Vehicle | Vehicle no., insurer, policy no., IDV, expiry date, type (comprehensive/TP) |
| Home | Property, insurer, coverage type, sum insured, expiry date |
| Custom | Free-form: name, insurer, premium, expiry date, notes |

**Reminders:** Push notifications at 30 days, 7 days, 1 day before expiry

---

### 4.2 — Tax Corner

**Files to create:**
```
lib/features/tax/
├── controllers/tax_controller.dart
├── views/tax_screen.dart
└── widgets/
    ├── section_80c_tracker.dart    # Running total vs ₹1.5L limit
    ├── capital_gains_summary.dart
    └── tax_export_button.dart      # Export PDF
```

**80C investments auto-aggregated from assets:**
- ELSS mutual funds
- PPF contributions
- LIC premiums (from insurance)
- Home loan principal (from liabilities)
- Manual additions (ULIP, NSC, school fees)

**Capital gains from stocks/MF:**
- Short-term (held < 1 year): 15% tax
- Long-term (held > 1 year): 10% tax above ₹1L

**Packages to add:** `pdf`, `printing`

---

### Phase 4 — Test Checklist

```
[ ] Add health insurance → expiry reminder fires 30 days before
[ ] LIC premium added to insurance → auto-appears in 80C
[ ] Sold stock held > 1 year → classified as LTCG
[ ] 80C limit tracker shows correct total
[ ] Export tax PDF → opens readable document
```

---

## PHASE 5 — Intelligence

> **Goal:** AI and automation make Cashense feel magical.
> **Deliverable:** Transactions can be logged by talking. Insights are proactive.

### 5.1 — Analytics & Reports

**Files to create:**
```
lib/features/analytics/
├── controllers/analytics_controller.dart
├── views/analytics_screen.dart
└── widgets/
    ├── spending_trend_chart.dart   # Monthly bars (fl_chart)
    ├── category_pie_chart.dart
    ├── income_vs_expense.dart      # Side-by-side bar
    ├── cash_flow_waterfall.dart
    └── export_report_button.dart   # CSV / PDF
```

**Views:** Weekly / Monthly / Yearly toggle

---

### 5.2 — AI Assistant

**Files to create:**
```
lib/features/ai_assistant/
├── controllers/ai_controller.dart
├── views/ai_chat_screen.dart
└── widgets/
    ├── chat_bubble.dart
    ├── transaction_confirmation_card.dart  # "Add ₹350 food expense?"
    └── insight_card.dart
```

**Capabilities:**
- Parse natural language: "spent 500 on lunch at Zomato today" → creates transaction draft
- Monthly spending insights: "You spent 40% more on dining vs last month"
- Anomaly detection: "Unusual transaction: ₹12,000 at Amazon"
- Goal advice: "At current rate, you'll miss your vacation goal by 2 months"
- FD advice: "Your FD at HDFC matures in 15 days. Current SBI rate is 0.5% higher."

**Backend:** OpenAI `gpt-4o-mini` via Firebase Cloud Functions (keeps API key server-side)

---

### 5.3 — FD Maturity & Stock Alerts

**Files to create:**
```
lib/features/alerts/
├── controllers/alerts_controller.dart
├── views/alerts_screen.dart        # Alert history
└── widgets/alert_tile.dart
```

**Alert types:**
- FD matures in 30/7/1 days
- Stock price above/below user-set threshold
- MF NAV milestone
- Bill overdue

**Backend:** Firebase Cloud Functions cron job (runs daily at 9 AM IST)

---

### 5.4 — SMS / UPI Auto-Import (Android only)

**Files to create:**
```
lib/features/sms_import/
├── controllers/sms_controller.dart
├── views/sms_review_screen.dart    # Review parsed transactions before saving
└── widgets/sms_draft_card.dart     # "Add this transaction?"
```

**Flow:**
1. Request SMS permission on Android
2. Read SMS inbox (last 30 days on first run, then incremental)
3. Parse using regex patterns for major Indian banks (SBI, HDFC, ICICI, Axis, Kotak)
4. Create transaction drafts for user to confirm/reject
5. Remember confirmed patterns to auto-accept similar future SMS

**Package to add:** `telephony` (Android only, guard with `Platform.isAndroid`)

---

### 5.5 — Subscription Tracker

**Files to create:**
```
lib/features/subscriptions/
├── controllers/subscriptions_controller.dart
├── views/
│   ├── subscriptions_screen.dart
│   └── add_subscription_screen.dart
└── widgets/
    ├── subscription_card.dart
    └── monthly_spend_summary.dart  # Total monthly subscription cost
```

**Auto-detect:** Scan transactions for recurring amounts from known merchants (Netflix, Spotify, Amazon Prime, Disney+, Zomato Pro, etc.)

**Renewal reminders:** 7 days before next billing date

---

### Phase 5 — Test Checklist

```
[ ] "spent 200 on chai" → AI creates transaction draft → user confirms → saved
[ ] Monthly insight appears after 30 days of data
[ ] FD maturity alert fires 30 days before maturity date
[ ] SMS import: HDFC debit SMS parsed into transaction draft
[ ] Analytics monthly chart shows accurate category breakdown
[ ] Subscription detected from recurring Amazon Prime charge
```

---

## PHASE 6 — Scale

> **Goal:** Multi-user support and advanced features.
> **Deliverable:** Families and couples can use Cashense together.

### 6.1 — Multi-Workspace / Family Finance

**Concepts:**
- **Workspace:** A shared finance space (personal, family, couple, business)
- **Members:** Owner can invite by email/phone
- **Roles:** Admin (full access), Editor (add/edit), Viewer (read only)
- **Shared data:** Budgets, bills, groups visible to all members
- **Private data:** Each member's personal accounts/transactions optionally hidden

**Firestore structure:**
```
workspaces/{workspaceId}/
  members: [{uid, role}]
  budgets/
  bills/
  → each member's transactions remain in users/{uid}/transactions
    but tagged with workspaceId for shared views
```

---

### 6.2 — Advanced Tax Features

- GST invoice generation (for freelancers)
- Form 16 upload + auto-parse salary income
- Advance tax calculator (quarterly)
- HRA exemption calculator
- Home loan tax benefit calculator (Section 24)

---

### Phase 6 — Test Checklist

```
[ ] Create family workspace, invite spouse
[ ] Spouse sees shared bills and budgets
[ ] Personal accounts remain private unless shared
[ ] Tax calculations match ITR utility estimates
```

---

## Packages to Add (Not Yet in pubspec.yaml)

| Package | Phase | Purpose |
|---------|-------|---------|
| `fl_chart` | 3 | Charts for net worth, analytics |
| `flutter_local_notifications` | 1 | Bill and budget notifications |
| `firebase_messaging` | 1 | FCM push notifications |
| `firebase_functions` | 5 | Cloud Functions calls |
| `confetti` | 3 | Net worth milestone celebrations |
| `telephony` | 5 | SMS reading on Android |
| `pdf` | 4 | Tax report PDF generation |
| `printing` | 4 | PDF export/share |
| `share_plus` | 4 | Share reports |
| `image_picker` | 1 | Receipt photo attachment |
| `firebase_storage` | 1 | Store receipt images |

---

## Firestore Security Rules (Template)

```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // User's own data
    match /users/{userId}/{document=**} {
      allow read, write: if request.auth.uid == userId;
    }
    // Groups: members only
    match /groups/{groupId}/{document=**} {
      allow read, write: if request.auth.uid in resource.data.members;
    }
    // Workspaces: workspace members only
    match /workspaces/{workspaceId}/{document=**} {
      allow read: if request.auth.uid in resource.data.memberIds;
      allow write: if request.auth.uid == resource.data.ownerId
                   || (request.auth.uid in resource.data.memberIds
                       && resource.data.memberRoles[request.auth.uid] in ['admin', 'editor']);
    }
  }
}
```

---

## Future Scope (Post Phase 6)

| Feature | Value |
|---------|-------|
| Credit score tracker | Pull CIBIL/Experian score monthly |
| Crypto portfolio | Track BTC/ETH via CoinGecko API |
| Will & nominee manager | Asset-nominee mapping for estate planning |
| Cashback & rewards tracker | Credit card reward points |
| SIP planner | Calculate SIP to reach goals |
| Loan payoff simulator | "What if I pay ₹5000 extra/month?" |
| Receipt OCR | Scan paper receipts |
| WhatsApp bot | Log expenses via WhatsApp |
| Home screen widget | Net worth glanceable widget |
| Couple finance mode | Joint view with individual privacy toggle |
