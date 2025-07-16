# 📱 Cashense: Your Intelligent Finance Companion

Welcome to **Cashense** — a smart, scalable, and culturally-rooted personal finance application, designed to revolutionize the way individuals manage, track, and optimize their finances.

---

## 🔥 Vision

To empower every individual — from college students to working professionals — to **understand**, **control**, and **grow** their money using intuitive tools, intelligent automation, and community-driven finance features.

> "More than just an app — it's your personal financial conscience."

---

## 🌱 Mission

* To make **money management intuitive**, not intimidating.
* To **support smart saving** and intentional spending.
* To **scale from individual to group-based finance** with ease.
* To **infuse AI guidance** with native usability and cultural relevance.

---

## 🧩 Core Identity

* **App Name**: Cashense
* **Meaning**: A portmanteau of *Cash* + *Sense*, bringing clarity, control, and cleverness to every rupee
* **Target Market**: Young Indians, families, students, couples, and friends sharing group expenses
* **Tagline Options**:

  * "Make Every Rupee Count."
  * "Smart. Simple. Cashense."
  * "Track. Save. Grow. Together."

---

## 📋 Project Overview

Cashense is being developed with a phased approach, focusing on building a strong foundation first and progressively adding more complex features. Our implementation is divided into six phases:

1. **Core Foundation**: Accounts, transactions, and synchronization
2. **Financial Planning**: Budgeting, goals, and analytics
3. **Social Features**: Group expenses and debt tracking
4. **AI Integration**: Natural language and voice interfaces
5. **Advanced Features**: Bank integration and investment tracking
6. **Future Expansion**: Additional features post-initial release

For detailed implementation plans and technical documentation, see the [docs](docs/index.md) directory.

---

## 📂 Project Structure

```
cashense/
├── android/               # Android-specific configuration 
├── ios/                   # iOS-specific configuration
├── lib/
│   ├── core/              # Core utilities and constants
│   ├── data/              # Data models and repositories
│   ├── domain/            # Business logic and entities
│   ├── presentation/      # UI components
│   ├── features/          # Feature modules
│   ├── routes/            # App routing
│   ├── theme/             # App theming
│   └── main.dart          # App entry point
├── assets/                # App assets (images, fonts)
├── test/                  # Unit and widget tests
└── docs/                  # Documentation
```

For a more detailed structure, see [Project Structure](docs/project_structure.md).

---

## 📦 Key Modules

| Module                       | Description                                                                                                          |
| ---------------------------- | -------------------------------------------------------------------------------------------------------------------- |
| **Expense Tracking**         | Log daily transactions, filter by categories, tags, time, and accounts                                               |
| **Accounts & Sub-Accounts**  | Support for wallet, bank, UPI, and custom accounts with nested sub-accounts                                          |
| **Budgeting**                | Create monthly budgets, category-wise caps, and recurring goals                                                      |
| **Saving Goals**             | Define custom financial goals with timelines and AI recommendations                                                  |
| **Group Expenses**           | Add, split, settle, or collect expenses across friends, couples, and teams                                           |
| **Debt Tracker**             | Track money lent or borrowed with options to mark as collected, paid, or settled without affecting account balance    |
| **Subscription Manager**     | Track recurring subscriptions with renewal alerts and spending analytics                                             |
| **Recurring Transactions**   | Set up automated entries for regular income/expenses with customizable frequency                                     |
| **AI Assistant**             | Natural language & voice interface for adding transactions, suggesting budgets, reminding overages, and offering saving tips |
| **Cash & Manual Handling**   | Optional cash-tracking with physical denomination detail                                                             |
| **Linked Accounts**          | Optional bank integrations for automatic transaction syncing                                                         |
| **Smart Reminders & Alerts** | Notify users of budget breaches, goal timelines, dues from others, or settlement options                             |
| **Analytics & Insights**     | Visualizations, monthly summaries, pie charts, and income vs. expense trends                                         |
| **Multi-Workspace**          | Create separate financial spaces (notebooks) for personal, business, or specific projects                            |
| **Investment Tracking**      | Monitor stocks, mutual funds, fixed deposits, and other investment vehicles                                          |

---

## 🧐 Intelligent Features

* Conversational interface: *"I spent ₹500 on groceries yesterday from HDFC."* → auto-logged.
* Voice command support: Speak transactions and commands for hands-free operation.
* Smart classification: Suggests category and labels based on text or amount.
* Goal advisor: Suggests how much to save monthly to reach a custom financial target.
* Group sync: Real-time sync with other app users in shared accounts/groups.
* Settlement logic: Choose to **collect** (adds amount to your account) or **settle** (clears dues without balance impact).
* AI-powered saving strategies: Get personalized recommendations to optimize savings based on spending patterns.
* Smart onboarding: Choose from AI-recommended templates (student, family, professional) or let AI create a custom setup.
* Auto debt settlement: Intelligently suggest how to clear debts within groups with minimal transactions.
* Financial tips integration: Quick financial advice on loading screens and within the app dashboard.

---

## 🔒 Security & Personalization

* Biometric authentication (fingerprint and face unlock)
* End-to-end encryption for sensitive financial data
* Custom themes and appearance settings
* Adjustable font sizes and accessibility options
* Cross-device synchronization with offline support
* Automatic data backup and recovery options

---

## 🎯 User Personas

* **Riya**, a college student budgeting her monthly pocket money.
* **Amit & Neha**, a newly married couple using a joint "Home" account.
* **Sahil**, a working professional splitting car fuel expenses with 4 roommates.
* **Deepika**, a solo saver tracking every cash detail and planning for travel.
* **Vikram**, a freelancer managing both personal finances and business expenses in separate workspaces.

---

## 🌐 Tech Stack (Finalized)

* **Frontend**: Flutter (Dart) — managed with FVM (Flutter Version Management)
* **Backend**: Supabase (PostgreSQL, Auth, Storage, Edge Functions)
* **Database**: PostgreSQL (via Supabase)
* **Authentication**: Supabase Auth
* **AI Integration**: OpenAI API (for NLP & suggestions)
* **Push Notifications**: Firebase Cloud Messaging (FCM)
* **CI/CD**: GitHub Actions (for backend and Flutter builds), Codemagic (optional for Flutter app distribution)

For detailed technical requirements and dependencies, see [Tech Requirements](docs/tech_requirements.md).

---

## 🚀 Getting Started

For developer setup instructions and contribution guidelines, see [Getting Started](docs/guides/getting_started.md).

---

## 📖 Documentation

Comprehensive documentation is available in the [docs](docs/index.md) directory, including:

* Detailed implementation plans for each phase
* Technical specifications and architecture
* Database schemas and API documentation
* Developer guides and standards
* UI/UX design specifications
* [Team Collaboration Plan](docs/team_collaboration.md)

---
