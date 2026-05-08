# Cashense — Claude Base File

> Read this file first in every session. It is the single source of truth for the project.

---

## What Is Cashense

Cashense is a personal finance super-app for India. It combines:
- **Splitwise-style** group expense splitting & debt settlement
- **Budget tracking** with category budgets and alerts
- **Bill & subscription reminders** with push notifications
- **Assets tracker** — FDs, stocks, mutual funds, gold, real estate, PPF/EPF
- **Liabilities tracker** — loans, EMIs, credit cards
- **Insurance vault** — policies, premiums, renewal reminders
- **Net worth dashboard** — assets minus liabilities with trend charts
- **AI assistant** — NLP transaction input, insights, anomaly detection

**Target users:** Young Indian professionals (22–40) who want one app to see their complete financial picture.

---

## Tech Stack

| Layer | Technology |
|-------|-----------|
| Framework | Flutter + Dart ^3.8.1 |
| State Management | GetX |
| Backend | Firebase (Auth, Firestore, Analytics) |
| Navigation | go_router (configured, not yet implemented) |
| Local DB | Drift (SQLite) |
| HTTP | Dio |
| Environments | Dev / Staging / Prod flavors |

**Firebase Projects:** `cashense-dev`, `cashense-staging`, `cashense` (prod)

---

## Architecture

```
lib/
├── features/         # Feature modules (auth done; all others pending)
│   └── authentication/
├── data/
│   └── services/     # Firebase, Auth services
├── common/widgets/   # Shared UI components
├── bindings/         # GetX global DI
├── routes/           # go_router (all files EMPTY — implement first)
├── flavors/          # Dev/staging/prod config
└── utils/            # Logger, theme, helpers, formatters, validators
```

**Pattern per feature:**
```
features/{name}/
├── bindings/         # GetX DI
├── controllers/      # GetX state management
├── models/           # Data models
└── views/            # Screens & widgets
```

---

## Current Status (May 2026)

### Done (Phase 0)
- [x] Project scaffolding, clean architecture, flavors
- [x] Firebase multi-environment (dev/staging/prod)
- [x] Google Sign-In + Firebase Auth (Android)
- [x] Material 3 theme (light/dark)
- [x] Core utilities (logger, formatters, validators, device helpers)
- [x] Routing (go_router) — `lib/routes/`
- [x] 9 core data models — `lib/data/models/`
- [x] Home dashboard scaffold (empty state)

### Up Next: Phase A — Auth + Net Worth Skeleton (target end May 28)
- [ ] Add Phone OTP auth (Google + OTP per locked decision)
- [ ] Net worth dashboard with empty state (the launch hero)
- [ ] Wealth tab: assets/liabilities list shells
- [ ] Bottom navigation: Home / Wealth / Transactions / Settings

### Deferred (no longer blockers)
- iOS Google Sign-In TODOs in `flavor_constants.dart` — Android-first launch, iOS is v1.1+

### Full Plan
See `docs/ROADMAP.md` for vision, scope, phases A–I, decision log, and discipline rules.

---

## Key Files

| File | Purpose |
|------|---------|
| `lib/main.dart` | Entry point |
| `lib/app.dart` | Root widget, theme, routing |
| `lib/routes/` | Navigation (EMPTY — implement Phase 0) |
| `lib/flavors/flavor_config.dart` | Dev/staging/prod settings |
| `lib/utils/constants/flavor_constants.dart` | iOS OAuth TODOs here |
| `lib/features/authentication/` | Only complete feature |
| `lib/data/services/authentication_service.dart` | Google Sign-In logic |

---

## Docs

| Document | Purpose |
|----------|---------|
| `docs/ROADMAP.md` | **Single source of truth** — vision, v1 scope, phases, decisions, workflow |
| `docs/FIRESTORE_SCHEMA.md` | Database collections design |
| `docs/V1_BACKLOG.md` | Created when first deferred request arrives |
| `docs/BETA_FEEDBACK.md` | Created at start of Phase H (closed beta) |

---

## Rules for Claude

1. Always read this file and `docs/ROADMAP.md` before starting any session
2. Work one phase at a time — do not jump ahead without user saying "done"
3. Never commit — give commands, let human execute
4. Run `flutter analyze` guidance after every phase
5. Update phase status in `docs/ROADMAP.md` §13 as phases complete
6. iOS auth is **deferred** (Android-first); do not flag iOS TODOs as blockers
7. Respect the cuts list (`docs/ROADMAP.md` §3 OUT) — new feature requests for AI/SMS/goals/receipts/live-prices go to `docs/V1_BACKLOG.md`, not the active phase
8. All Firestore access through Repository classes, never direct in controllers
9. Never put API keys in client code — use Firebase Cloud Functions
