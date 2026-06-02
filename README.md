# Cashense

> A personal finance super-app for young Indians. Everything you own and owe, in one screen — daily expenses, group splits, budgets, bills, and a net-worth dashboard.

Young Indians juggle Splitwise, spreadsheets, bank apps, and broker apps. Cashense combines Splitwise-style group splitting, daily expense/budget/bill tracking, and a complete net-worth dashboard (assets + liabilities) into one calm, India-first app. The marketing wedge is the **Net Worth Dashboard** — *"See everything you own and owe in one screen"* — which ships early (empty state) and gets richer each phase; every other feature is the daily-use layer underneath.

**User #1 = Yaksi.** This is a portfolio/learning build in a brutally saturated market (Cred, Jupiter, Slice, Fi, Walnut, Khatabook). The defensible angle is the *combination*, not any single feature — said plainly so the scope stays honest.

**Stack:** Flutter 3 (Dart ^3.8.1, FVM) · GetX (state + DI) · go_router (`GetMaterialApp.router`) · Firebase (Auth, Firestore, Analytics) · Drift (present, unused at v1) · Dio · Android-first.

**v1 (Dec 31, 2026):** app live on the Play Store, first 100 installs, one post-launch fix shipped. Manual asset values at launch; AI/NLP, SMS import, live price feeds, iOS, and insurance are v1.1+.

## Getting started

```bash
cd cashense          # the Flutter app is nested one level down
fvm flutter pub get
fvm flutter run --flavor dev -t lib/flavors/main_development.dart
```

> **Repo layout:** the Flutter app is nested at [`cashense/`](cashense/) (pubspec, lib, android, ios). Planning docs and contracts live at the repo root.

**Docs:** Machine-readable contracts live in [contracts/](./contracts). Full plan & spec: kept in the portfolio `planning/` workspace (not in this public repo).
