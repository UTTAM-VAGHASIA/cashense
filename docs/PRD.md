# Cashense — Product Requirements Document

**Version:** 1.0 | **Date:** April 15, 2026 | **Status:** In Development

---

## 1. Vision

> **"Every rupee you own, owe, earn, or insure — visible in one place."**

Cashense is a personal finance super-app for India. It replaces the fragmented experience of juggling Splitwise, Excel sheets, bank apps, and insurance folders with a single intelligent platform that tracks your complete financial life.

---

## 2. Problem

Young Indians manage money across 6–10 disconnected places:
- UPI apps (PhonePe, GPay) — for payments
- Splitwise — for group expenses
- Spreadsheets — for budgets
- Physical folders — for insurance policies
- Broker apps (Zerodha, Groww) — for investments
- Bank apps (3–4 different ones) — for accounts

**Result:** No one knows their true net worth. No one knows if they're on track. Reminders are missed. Money is lost.

---

## 3. Solution

One app that is the single source of truth for your entire financial life.

```
+-------------------------------------------------------------+
|  1. SPEND       2. OWE       3. INVEST      4. PROTECT     |
|  Expenses       Groups       Assets         Insurance       |
|  Budgets        Debts        Net Worth      Renewals        |
|  Bills          Settle       Goals          Tax             |
+-------------------------------------------------------------+
                          ↑
              AI layer connecting everything
```

---

## 4. Target Users

| Persona | Age | Pain |
|---------|-----|------|
| Young Professional | 22–30 | No idea where money goes |
| New Investor | 25–35 | FDs/stocks scattered across apps |
| Family CFO | 30–50 | Managing everyone's expenses + insurance |
| Debt-Juggler | 28–40 | 3 EMIs, 2 credit cards, no clarity |

---

## 5. Features

### 5.1 — Daily Money Management

**Expense Tracking**
- Add income/expense/transfer in <10 seconds
- 30+ categories + custom categories
- Multiple accounts (bank, cash, UPI wallet, credit card)
- Recurring transactions
- Receipt photo attachment
- SMS/UPI auto-import (Android)

**Budgets**
- Monthly budget per category
- Real-time progress with color coding
- Push alerts at 80% and 100% used

**Bills & Subscriptions**
- Track recurring bills (rent, EMI, utilities, OTT)
- Push reminders 7 days and 1 day before due
- Mark as paid in one tap
- Subscription spend summary

---

### 5.2 — Social Finance

**Group Expenses**
- Create groups: trips, roommates, events
- Add expenses with equal / % / exact split
- Debt simplification (minimize # of payments to settle)
- Settle up via UPI deep link
- Settlement history

---

### 5.3 — Wealth Tracking

**Assets**

| Type | What's Tracked |
|------|---------------|
| Fixed Deposits | Principal, rate, maturity date, interest |
| Stocks | Symbol, qty, buy price, live P&L |
| Mutual Funds | Units, buy NAV, current value |
| Gold | Grams, buy price, current value |
| Real Estate | Purchase value, estimated value |
| PPF/EPF/NPS | Balance, contributions |

**Liabilities**

| Type | What's Tracked |
|------|---------------|
| Loans | EMI, remaining principal, tenure |
| Credit Cards | Outstanding, limit, billing date |

**Net Worth = Assets − Liabilities** with monthly trend chart

**Saving Goals**
- Set targets with deadlines
- Track progress automatically
- AI-suggested monthly contribution

---

### 5.4 — Protection

**Insurance Vault**
- Store all policies (term, health, vehicle, home)
- Premium due reminders 30/7/1 days before
- Nominee information stored safely

**Tax Corner**
- 80C tracker vs ₹1.5L limit (auto-populates from assets)
- Capital gains summary (STCG/LTCG)
- Exportable tax report PDF

---

### 5.5 — AI Layer

- Natural language transaction input: "spent 500 on dinner"
- Monthly spending insights
- Anomaly detection
- FD maturity and stock price alerts
- Goal progress forecasting

---

## 6. Non-Goals (v1)

- Not a payment gateway (no money movement)
- Not a trading platform (tracking only, no buy/sell)
- Not a credit score app (no bureau integration in v1)
- Not a robo-advisor (suggestions only, no execution)

---

## 7. Technical Stack

| Layer | Technology |
|-------|-----------|
| Mobile | Flutter + Dart (iOS + Android) |
| State | GetX |
| Backend | Firebase (Auth, Firestore, Functions, FCM) |
| Navigation | go_router |
| Charts | fl_chart |
| AI | OpenAI gpt-4o-mini via Cloud Functions |
| Notifications | flutter_local_notifications + FCM |

---

## 8. Success Metrics

| Metric | Target (Month 6) |
|--------|-----------------|
| DAU/MAU ratio | >40% |
| Transactions logged per user per month | >20 |
| Avg assets added per user | >3 |
| Insurance policies stored per user | >1 |
| D7 retention | >35% |
| Rating (Play Store / App Store) | >4.2 |

---

## 9. Milestones

| Phase | Features | Target |
|-------|---------|--------|
| Phase 0 | iOS auth, routing, models | Week 1 |
| Phase 1 | Expense tracking, accounts, budgets, bills | Weeks 2–7 |
| Phase 2 | Group expenses, debt settlement | Weeks 8–11 |
| Phase 3 | Assets, liabilities, net worth, goals | Weeks 12–17 |
| Phase 4 | Insurance vault, tax corner | Weeks 18–21 |
| Phase 5 | AI, SMS import, analytics, alerts | Weeks 22–27 |
| **Beta Launch** | All phases complete | **Week 28** |
| Phase 6 | Family mode, advanced tax | Weeks 28–36 |
| **Public Launch** | Polished, tested | **Week 36** |

---

## 10. Future Scope

| Feature | Why |
|---------|-----|
| Credit score tracker | CIBIL/Experian integration |
| Crypto portfolio | CoinGecko API |
| Will & nominee manager | Estate planning |
| Cashback tracker | Credit card rewards |
| SIP planner | Goal-based investing |
| Loan payoff simulator | Prepayment analysis |
| Receipt OCR | Scan paper receipts |
| WhatsApp bot | Log via WhatsApp message |
| Home screen widget | Glanceable net worth |
| Couple finance mode | Joint view with privacy toggle |
