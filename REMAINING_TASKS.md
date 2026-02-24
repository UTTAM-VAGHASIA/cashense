# 📋 Cashense — Remaining Tasks
> Last updated: February 24, 2026
> Stack: Flutter + Firebase + GetX + OpenAI API

---

## ⚠️ Current Status
Only **authentication** is scaffolded under `lib/features/authentication/`. All other features are unbuilt.
The app has proper flavors (dev/staging/prod), routing, and utility setup, but no actual financial logic yet.

---

## 🔴 Phase 1 — Core Foundation

### Accounts & Transactions
- [ ] Account data model (wallet, bank, UPI, custom + sub-accounts)
- [ ] Add/Edit/Delete account screens
- [ ] Transaction data model (income, expense, transfer)
- [ ] Add transaction screen (manual entry)
- [ ] Transaction list + filter (by account, category, date, tag)
- [ ] Transaction detail screen
- [ ] Firebase Firestore schema + security rules

### Home Dashboard
- [ ] Dashboard screen (total balance, recent transactions, quick-add button)
- [ ] Income vs. expense summary card
- [ ] Bottom navigation bar

### Authentication (finalize)
- [ ] Complete email/password auth flow (sign in, sign up, forgot password)
- [ ] Google Sign-In
- [ ] Biometric unlock (fingerprint/face)
- [ ] Firestore user profile document on registration

---

## 🔴 Phase 2 — Financial Planning

- [ ] Budgeting module: create monthly budgets by category, track overspend
- [ ] Saving Goals: define goals with timeline + progress bar
- [ ] Recurring transactions: automated entries (salary, rent, subscriptions)
- [ ] Subscription manager: track renewals + spending analytics
- [ ] Analytics & Insights: pie charts, monthly summary, income vs. expense trend (`fl_chart`)

---

## 🔴 Phase 3 — Social Features

- [ ] Group expenses: add expense → split → assign to members
- [ ] Settle payment: collect (add to balance) or settle (clear dues only)
- [ ] Debt tracker: money lent/borrowed, mark as paid/collected
- [ ] Auto debt settlement: suggest minimum transactions to clear group debts
- [ ] Real-time group sync (Firestore listeners)

---

## 🟡 Phase 4 — AI Integration

- [ ] OpenAI API integration (NLP for natural language transaction entry)
  - e.g. *"I spent ₹500 on groceries yesterday from HDFC"* → auto-logged
- [ ] Voice command support (speech-to-text → NLP pipeline)
- [ ] Smart categorization (suggest category from description/amount)
- [ ] Goal advisor: how much to save per month to reach goal
- [ ] Smart onboarding templates (student, couple, professional)

---

## 🟡 Phase 5 — Advanced Features

- [ ] Bank/UPI integration for automatic transaction syncing
- [ ] Investment tracking (stocks, mutual funds, FDs)
- [ ] Multi-workspace support (personal, business, project notebooks)
- [ ] Cash tracking with denomination detail

---

## 🟢 Phase 6 — Polish & Launch

- [ ] Push notifications via FCM (budget breach, goal reminders, incoming dues)
- [ ] Smart reminders & alerts system
- [ ] Offline support + cross-device sync
- [ ] Data backup and recovery
- [ ] Custom themes + accessibility (font size, color)
- [ ] CI/CD pipeline (GitHub Actions + Codemagic)
- [ ] App Store + Play Store release

---

## 📌 Notes
- FVM is configured (`.fvmrc` present) — use `fvm flutter` commands
- Flavors: `main_development.dart`, `main_staging.dart`, `main_production.dart`
- State management: GetX (already wired in `bindings/`)
- No backend has been connected yet — Firebase project needs to be initialized
