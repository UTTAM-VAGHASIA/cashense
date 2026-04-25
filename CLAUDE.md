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

## Current Status (April 2026)

### Done
- [x] Project scaffolding, clean architecture, flavors
- [x] Firebase multi-environment (dev/staging/prod)
- [x] Google Sign-In + Firebase Auth (Android & Web)
- [x] Material 3 theme (light/dark)
- [x] Core utilities (logger, formatters, validators, device helpers)
- [x] Auth flow UI (Welcome, Login, Biometrics screens)

### Immediate Blockers (do these first)
- [ ] iOS Google Sign-In client ID (flavor_constants.dart — 3 TODOs)
- [ ] App navigation & routing (go_router — routes/ folder is empty)
- [ ] Core data models (Transaction, Account, Budget, Goal, Group)

### Not Started
See `docs/MASTER_PLAN.md` for the full phase-wise breakdown.

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
| `docs/MASTER_PLAN.md` | Phase-wise feature plan with file-level tasks |
| `docs/AGENT_WORKFLOW.md` | How agent and human work together |
| `docs/FIRESTORE_SCHEMA.md` | Database collections design |
| `docs/PRD.md` | Full product requirements document |

---

## Rules for Claude

1. Always read this file and `docs/MASTER_PLAN.md` before starting any session
2. Work one phase at a time — do not jump ahead without user saying "done"
3. Never commit — give commands, let human execute
4. Run `flutter analyze` guidance after every phase
5. Mark tasks done in MASTER_PLAN.md as phases complete
6. iOS Google Sign-In is broken until `flavor_constants.dart` TODOs are filled
