# Project Name: Cashense

## Tagline:
**"The AI-First Expense Operating System—For Everyone from Individuals to Enterprises."**

## Summary:
**Cashense** is an AI-native personal & group expense manager that combines the best ideas from Splitwise, Walnut, Notion, and Fireflies.ai into a next-gen expense ecosystem. Designed for solopreneurs, friend groups, families, and SMBs, users can create smart "Cashbooks"—modular expense ledgers for every context (projects, roommates, startups, trips)—with collaborative controls, AI explanations, real-time analytics, and receipt intelligence.

---

## Personal Vision

**Cashense** is a long-term, income-generating personal project built with care, depth, and scalability in mind. The goal is to:

- Launch an innovative product for both individual and team use
- Incorporate AI into real-world finance tooling
- Monetize via freemium and enterprise plans
- Iterate over multiple versions for stability, growth, and delight
- Build using Flutter for cross-platform performance and native-like experiences

---

## Tech Stack (July 2025)

### 🔹 **Frontend**
- **Flutter SDK** ≥ 3.7 (Dart ≥ 3.3)

### 🔹 **Firebase Backend**
| Package           | Version |
| ----------------- | ------- |
| `firebase_core`   | ^2.14.0 |
| `cloud_firestore` | ^4.9.0  |
| `firebase_auth`   | ^4.6.0  |
| `cloud_functions` | ^4.5.0  |

### 🔹 **Local Database (Isar)**
| Package             | Version  |
| ------------------- | -------- |
| `isar`              | ^3.1.0+1 |
| `isar_flutter_libs` | ^3.1.0+1 |
| `isar_generator`    | ^3.1.0+1 |
| `build_runner`      | ^2.4.0   |

### 🔹 **Connectivity / Offline Detection**
| Package                            | Version |
| ---------------------------------- | ------- |
| `connectivity_plus`                | ^6.1.4  |
| `internet_connection_checker_plus` | ^2.0.0  |

### 🔹 **State Management**
| Package               | Version |
| --------------------- | ------- |
| `flutter_riverpod`    | ^2.2.0  |
| `riverpod_annotation` | ^2.6.1  |
| `riverpod_generator`  | ^2.2.0  |
| `riverpod_lint`       | ^2.0.0  |

### 🔹 **Navigation**
| Package     | Version |
| ----------- | ------- |
| `go_router` | ^8.1.0  |

### 🔹 **HTTP Client**
| Package | Version |
| ------- | ------- |
| `dio`   | ^6.0.0  |

### 🔹 **Authentication & Security**
| Package                  | Version |
| ------------------------ | ------- |
| `local_auth`             | ^2.1.8  |
| `local_auth_android`     | ^1.0.43 |
| `local_auth_darwin`      | ^1.5.0  |
| `flutter_secure_storage` | ^9.0.0  |

### 🔹 **Developer / Debug Tools (Optional)**
| Package          | Version  |
| ---------------- | -------- |
| `flutter_hooks`  | ^0.20.5  |
| `isar_inspector` | ^3.1.0+3 |

---

## Core Features

### 🔗 Modular Cashbooks
- Create separate "Cashbooks" for:
  - Personal tracking
  - Group trips
  - Family expenses
  - Business projects
- Each cashbook maintains:
  - Accounts & Sub-accounts
  - Group members
  - Loans & debts
  - Shared ownership & permissions

### 🧠 AI + Voice + Video Assistants
- Ask: “Explain this expense” or “Summarize group spend in April”
- AI-generated video explainers
- AI-generated audio reports
- Voice/chat assistant for adding transactions

### 🤝 Group Expense Mode (Splitwise+)
- Invite members to Cashbooks
- Auto-split shared expenses
- Weighted splits, UPI reimbursements
- One-off group tagging

### 📋 Receipt Intelligence
- Upload bills/invoices
- AI parses and tags expenses
- Detect duplicates and categorize automatically

### 📊 Smart Budgeting & Saving Goals
- Budget limits inside Cashbooks
- Alerts, savings targets, nudges
- AI: “Overspending on food this week”

### 💰 Sub-Account Logic
- Handle fund shortfalls intelligently
- Inter-sub-account transfers

### 💳 Debt & Loan Ledger
- Log and manage debts within Cashbooks
- Actions: Settle, Collect, Reassign

### 🔐 Ghost Mode Cashbooks
- PIN/biometric protected private Cashbooks

### 🗓 Visual Timeline View
- Diary-style calendar of expenses
- AI summaries, media, notes per day

### 🤖 Auto-Reconciliation Agent
- Upload bank statements (PDF/CSV)
- AI matches with logged transactions
- Flags anomalies

### 🌐 Collaborative Cashbooks
- Multi-user, role-based expense management

### 🌍 FinanceVerse Mode (Top-Secret Future Vision)
- Connect multiple cashbooks
- AI predicts cross-impact:
  - “Delaying vendor payout improves savings goal timeline”
- Visualize financial flow as a network

---

## Monetization Plan

**Freemium**
- 3 Cashbooks
- Limited AI usage

**Pro Plan**
- Unlimited Cashbooks
- Access to premium AI features

**Enterprise Plan**
- Team workspace features
- White-labeled apps
- Admin-level controls and auditing

---

## MVP Sprint Plan (Realistic Timeline)

| Day | Focus Area                                                  |
| --- | ----------------------------------------------------------- |
| 1   | Flutter project setup, authentication, dashboard UI         |
| 2   | Cashbook creation, listing, deletion                        |
| 3   | Expense form, local logic, AI explanation (OpenAI API)      |
| 4   | Group invites, shared ledger, split logic                   |
| 5   | Audio/video AI assistant integration                        |
| 6   | Receipt upload, OCR + AI tagging                            |
| 7   | UI polish and bug fixes                                     |

---

## Competitor Landscape

| Competitor         | Strengths                   | Weaknesses (Our Edge)                   |
| ------------------ | --------------------------- | --------------------------------------- |
| Splitwise          | Group splitting             | No AI, no modular books, no voice/video |
| Walnut             | SMS-based tracking in India | No groups, no modular books             |
| Goodbudget         | Envelope method             | Clunky UI, lacks AI                     |
| Notion + Templates | Custom expense pages        | Manual, no financial logic              |
| Fireflies.ai       | AI for meetings             | Doesn’t handle expenses                 |

**Cashense is the first AI-native, modular expense ecosystem built for real-world financial flow.**

