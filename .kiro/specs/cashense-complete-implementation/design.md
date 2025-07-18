# Cashense Design Document

## Overview

Cashense is a comprehensive financial management platform built with Flutter and Firebase, designed to provide intelligent expense tracking, AI-powered features, social finance capabilities, and advanced analytics across mobile, web, and desktop platforms. The system prioritizes cost-effectiveness while delivering enterprise-grade functionality through Firebase's generous free tiers and Flutter's cross-platform capabilities.

The project is designed with a strategic foundation-first approach, implementing theming, localization, multi-currency support, and comprehensive documentation from the beginning to support rapid, scalable development by multiple developers working simultaneously.

### Key Design Principles

- **Cost-Effective**: Built on Firebase free tiers targeting $0-10/month operational costs
- **Cross-Platform**: Single Flutter codebase for mobile, web, and desktop
- **AI-Powered**: Intelligent categorization using Firebase AI Logic and Gemini
- **Offline-First**: Full functionality with Hive local storage and Firebase sync
- **Scalable**: Firebase backend scales automatically with usage-based pricing
- **Developer-Friendly**: Riverpod state management with code generation tools
- **Documentation-First**: Comprehensive documentation and best practices from project start
- **Foundation-First**: Strategic setup of theming, localization, and utilities before feature development
- **Multi-Developer Ready**: Modular architecture supporting parallel development without conflicts

## Architecture

### High-Level Architecture

The system follows a client-server architecture with Firebase as the backend-as-a-service:

```
┌─────────────────────────────────────────────────────────────┐
│                    Flutter Application                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │   Mobile    │  │     Web     │  │      Desktop        │  │
│  │    (iOS/    │  │   (PWA)     │  │   (Windows/Mac/     │  │
│  │   Android)  │  │             │  │      Linux)         │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
                    ┌─────────────────┐
                    │    Riverpod     │
                    │ State Management│
                    └─────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Local Storage Layer                      │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │    Hive     │  │   Secure    │  │    SharedPrefs      │  │
│  │  Database   │  │   Storage   │  │    (Settings)       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
                              │
┌─────────────────────────────────────────────────────────────┐
│                    Firebase Backend                         │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Firestore  │  │    Auth     │  │      Storage        │  │
│  │  Database   │  │   Service   │  │     (Files)         │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────┐  │
│  │  Functions  │  │ AI Logic/   │  │    Analytics/       │  │
│  │ (Serverless)│  │   Gemini    │  │   Crashlytics       │  │
│  └─────────────┘  └─────────────┘  └─────────────────────┘  │
└─────────────────────────────────────────────────────────────┘
```

### Technology Stack

**Frontend Framework:**
- Flutter SDK (latest stable via FVM) for cross-platform development
- Material 3 design system for consistent UI/UX
- Single codebase targeting mobile, web, and desktop

**State Management:**
- Riverpod (latest version) for compile-time safety and advanced async/sync providers
- Provider as fallback for simpler use cases

**Backend & Database (Firebase-Only):**
- Firebase Firestore for primary data storage (1GB + 50K reads/20K writes free)
- Firebase Authentication for user management (50K MAU free tier)
- Firebase Storage for file attachments (5GB free, requires Blaze plan after Oct 2025)
- Firebase Functions for serverless backend logic (2M invocations/month free)
- Firebase Hosting for web deployment (10GB storage + 360MB/day transfer free)

**AI/ML Integration:**
- Firebase AI Logic (Vertex AI integration) for intelligent categorization
- Gemini in Firebase for contextual awareness and insights
- OpenAI API for advanced NLP processing (pay-per-use, cost-optimized)
- Local alternatives: flutter_tts + speech_to_text for offline voice features

**Local Storage:**
- Hive for mobile/desktop/web local storage (faster than Isar, simpler API)
- flutter_secure_storage for sensitive data encryption
- SharedPreferences for app settings and preferences

**Additional Services:**
- Firebase Cloud Messaging for push notifications (free)
- Firebase Analytics for user behavior tracking (unlimited events)
- Firebase Crashlytics for error monitoring (unlimited crash reports)
- Firebase Performance Monitoring (free)

**Development Tools:**
- Mason for code templates and generators
- Very Good CLI for project scaffolding
- build_runner + freezed + json_annotation for code generation
- GitHub Actions for CI/CD (2,000 minutes/month free)
- FVM (Flutter Version Management) for consistent Flutter versions
- Melos for monorepo management and workspace coordination

**Documentation Tools:**
- Dart Doc for API documentation generation
- GitHub Pages for documentation hosting
- Markdown for comprehensive project documentation
- PlantUML/Mermaid for architecture diagrams

**Key Packages:**
```yaml
dependencies:
  # Core Flutter
  flutter:
    sdk: flutter
  
  # State management
  riverpod: ^2.6.1 
  flutter_riverpod: ^2.6.1 
  
  # Firebase suite
  firebase_core: ^3.15.1 
  firebase_auth: ^5.6.2 
  cloud_firestore: ^5.6.11 
  firebase_storage: ^12.4.9 
  firebase_analytics: ^11.5.2  
  firebase_crashlytics: ^4.3.9 
  firebase_messaging: ^15.2.9 
  cloud_functions: ^5.6.1 
  firebase_ai: ^2.2.1
  
  # Local storage
  hive: ^2.2.3
  hive_flutter: ^1.1.0
  flutter_secure_storage: ^9.2.4
  
  # Navigation & UI
  go_router: ^16.0.0  
  fl_chart: ^1.0.0 
  flutter_form_builder: ^10.1.0 
  
  # Theming & Material Design
  material_color_utilities: ^0.12.0
  dynamic_color: ^1.7.0
  
  # Localization & Internationalization
  flutter_localizations:
    sdk: flutter
  intl: ^0.19.0
  
  # Multi-currency support
  currency_picker: ^2.0.21
  money2: ^5.3.0
  
  # HTTP / API
  dio: ^5.8.0+1 
  
  # Voice & TTS
  speech_to_text: ^7.2.0
  flutter_tts: ^4.2.3
  
  # Utilities
  freezed_annotation: ^3.1.0
  json_annotation: ^4.9.0
  equatable: ^2.0.5
  collection: ^1.18.0
  
dev_dependencies:
  # Code generation
  build_runner: ^2.4.13
  freezed: ^2.6.0
  json_serializable: ^6.8.0
  hive_generator: ^2.0.1
  
  # Testing
  flutter_test:
    sdk: flutter
  mocktail: ^1.0.4
  integration_test:
    sdk: flutter
  
  # Linting & Analysis
  flutter_lints: ^5.0.0
  very_good_analysis: ^6.0.0
  
  # Documentation
  dartdoc: ^8.1.0
```

## Strategic Foundation Architecture

### Project Structure and Organization

The project follows a feature-first architecture with clear separation of concerns and modular design to support multiple developers working simultaneously:

```
lib/
├── main.dart                          # App entry point
├── app/                              # App-level configuration
│   ├── app.dart                      # Main app widget
│   ├── router/                       # Navigation configuration
│   ├── theme/                        # Theme configuration
│   └── localization/                 # Localization setup
├── core/                             # Core utilities and shared code
│   ├── constants/                    # App constants and enums
│   ├── extensions/                   # Dart extensions
│   ├── utils/                        # Utility functions
│   ├── validators/                   # Input validation
│   ├── formatters/                   # Data formatters
│   └── exceptions/                   # Custom exceptions
├── shared/                           # Shared components and services
│   ├── widgets/                      # Reusable UI components
│   ├── services/                     # Core services
│   ├── models/                       # Shared data models
│   └── providers/                    # Shared Riverpod providers
├── features/                         # Feature modules
│   ├── authentication/               # Auth feature
│   │   ├── data/                     # Data layer
│   │   ├── domain/                   # Business logic
│   │   ├── presentation/             # UI layer
│   │   └── providers/                # Feature providers
│   ├── accounts/                     # Account management
│   ├── transactions/                 # Transaction management
│   ├── budgets/                      # Budget management
│   ├── analytics/                    # Analytics and reporting
│   └── [other features]/
└── l10n/                            # Localization files
    ├── app_en.arb                   # English strings
    ├── app_es.arb                   # Spanish strings
    └── [other languages]/
```

### Theming System Architecture

The theming system is built on Material 3 design principles with comprehensive customization support:

```dart
@freezed
class AppTheme with _$AppTheme {
  const factory AppTheme({
    required ThemeMode themeMode,
    required ColorScheme lightColorScheme,
    required ColorScheme darkColorScheme,
    required Typography typography,
    required AppSpacing spacing,
    required AppBorderRadius borderRadius,
    required AppShadows shadows,
  }) = _AppTheme;
  
  factory AppTheme.fromJson(Map<String, dynamic> json) => _$AppThemeFromJson(json);
}

class ThemeService {
  static ThemeData createLightTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      typography: Typography.material2021(),
      appBarTheme: _createAppBarTheme(colorScheme),
      cardTheme: _createCardTheme(colorScheme),
      elevatedButtonTheme: _createElevatedButtonTheme(colorScheme),
      // ... other theme configurations
    );
  }
  
  static ThemeData createDarkTheme(ColorScheme colorScheme) {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: colorScheme,
      typography: Typography.material2021(),
      // ... dark theme specific configurations
    );
  }
}
```

### Localization Architecture

The localization system supports multiple languages with proper formatting and RTL support:

```dart
class AppLocalizations {
  static const List<Locale> supportedLocales = [
    Locale('en', 'US'), // English
    Locale('es', 'ES'), // Spanish
    Locale('fr', 'FR'), // French
    Locale('de', 'DE'), // German
    Locale('ar', 'SA'), // Arabic (RTL)
    Locale('hi', 'IN'), // Hindi
    Locale('zh', 'CN'), // Chinese
  ];
  
  static LocalizationsDelegate<AppLocalizations> get delegate =>
      _AppLocalizationsDelegate();
}

class LocalizationService {
  static String formatCurrency(double amount, String currencyCode, Locale locale) {
    final formatter = NumberFormat.currency(
      locale: locale.toString(),
      symbol: getCurrencySymbol(currencyCode),
    );
    return formatter.format(amount);
  }
  
  static String formatDate(DateTime date, Locale locale) {
    return DateFormat.yMMMd(locale.toString()).format(date);
  }
  
  static bool isRTL(Locale locale) {
    return ['ar', 'he', 'fa', 'ur'].contains(locale.languageCode);
  }
}
```

### Multi-Currency Support Architecture

The currency system handles real-time conversion and formatting:

```dart
@freezed
class Currency with _$Currency {
  const factory Currency({
    required String code,
    required String name,
    required String symbol,
    required int decimalPlaces,
    required bool isActive,
  }) = _Currency;
  
  factory Currency.fromJson(Map<String, dynamic> json) => _$CurrencyFromJson(json);
}

@freezed
class ExchangeRate with _$ExchangeRate {
  const factory ExchangeRate({
    required String fromCurrency,
    required String toCurrency,
    required double rate,
    required DateTime lastUpdated,
    required String source,
  }) = _ExchangeRate;
  
  factory ExchangeRate.fromJson(Map<String, dynamic> json) => _$ExchangeRateFromJson(json);
}

class CurrencyService {
  Future<double> convertAmount(
    double amount,
    String fromCurrency,
    String toCurrency,
  ) async {
    if (fromCurrency == toCurrency) return amount;
    
    final rate = await getExchangeRate(fromCurrency, toCurrency);
    return amount * rate.rate;
  }
  
  Future<ExchangeRate> getExchangeRate(String from, String to) async {
    // Implementation with multiple API fallbacks
    // 1. Try primary API (e.g., exchangerate-api.com)
    // 2. Fallback to secondary API
    // 3. Use cached rates if APIs fail
  }
  
  String formatAmount(double amount, String currencyCode, Locale locale) {
    final currency = getCurrency(currencyCode);
    final formatter = NumberFormat.currency(
      locale: locale.toString(),
      symbol: currency.symbol,
      decimalDigits: currency.decimalPlaces,
    );
    return formatter.format(amount);
  }
}
```

### Documentation Architecture

The documentation system provides comprehensive coverage for developers:

```
docs/
├── README.md                         # Main project documentation
├── CONTRIBUTING.md                   # Contribution guidelines
├── ARCHITECTURE.md                   # Architecture overview
├── API.md                           # API documentation
├── DEPLOYMENT.md                    # Deployment guide
├── TESTING.md                       # Testing strategies
├── TROUBLESHOOTING.md               # Common issues and solutions
├── adr/                             # Architecture Decision Records
│   ├── 001-flutter-firebase.md
│   ├── 002-state-management.md
│   └── [other ADRs]/
├── api/                             # Generated API docs
├── diagrams/                        # Architecture diagrams
│   ├── system-overview.puml
│   ├── data-flow.puml
│   └── deployment.puml
└── examples/                        # Code examples
    ├── authentication.md
    ├── transactions.md
    └── [other examples]/
```

### Multi-Developer Workflow Architecture

The development workflow is designed to minimize conflicts and maximize parallel development:

#### Module Boundaries and Interfaces

Each feature module has clearly defined interfaces and contracts:

```dart
// Feature interface contracts
abstract class AuthenticationRepository {
  Future<User> signIn(String email, String password);
  Future<void> signOut();
  Stream<User?> get authStateChanges;
}

abstract class TransactionRepository {
  Future<Transaction> create(CreateTransactionRequest request);
  Future<List<Transaction>> getAll(String cashbookId);
  Stream<List<Transaction>> watch(String cashbookId);
}

// Service layer interfaces
abstract class NotificationService {
  Future<void> sendNotification(NotificationRequest request);
  Future<void> scheduleNotification(ScheduledNotificationRequest request);
}
```

#### Development Streams

Three parallel development streams with minimal dependencies:

**Stream 1: Core Infrastructure & Authentication**
- Project setup and configuration
- Authentication system
- User management
- Security implementation

**Stream 2: Financial Data Management**
- Account management
- Transaction processing
- Budget and goals
- Analytics and reporting

**Stream 3: Advanced Features & Integration**
- AI and NLP processing
- Social finance features
- Bank integration
- Investment tracking

#### Integration Points and Contracts

Clear integration contracts between streams:

```dart
// Integration contracts
class IntegrationContracts {
  // Stream 1 provides to Stream 2
  static const authenticationContract = {
    'provides': ['User', 'AuthState', 'Permissions'],
    'interface': 'AuthenticationService',
  };
  
  // Stream 2 provides to Stream 3
  static const dataManagementContract = {
    'provides': ['Transaction', 'Account', 'Budget'],
    'interface': 'DataManagementService',
  };
  
  // Stream 3 integrates with Stream 1 & 2
  static const advancedFeaturesContract = {
    'requires': ['AuthenticationService', 'DataManagementService'],
    'provides': ['AIService', 'BankIntegrationService'],
  };
}
```

## Components and Interfaces

### Core Service Architecture

The application is structured around service providers managed by Riverpod, each handling specific business domains:

#### 1. Authentication Service
Manages user authentication and session handling using Firebase Auth.

**Key Interfaces:**
```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? photoURL,
    required UserProfile profile,
    required UserPreferences preferences,
    required SecuritySettings securitySettings,
    required DateTime createdAt,
    DateTime? lastLoginAt,
  }) = _User;
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class UserProfile with _$UserProfile {
  const factory UserProfile({
    required String firstName,
    required String lastName,
    String? avatar,
    required String timezone,
    required String language,
    required String currency,
  }) = _UserProfile;
  
  factory UserProfile.fromJson(Map<String, dynamic> json) => _$UserProfileFromJson(json);
}

abstract class AuthService {
  Future<User?> signInWithEmail(String email, String password);
  Future<User?> signUpWithEmail(String email, String password, UserProfile profile);
  Future<User?> signInWithGoogle();
  Future<void> signOut();
  Stream<User?> get authStateChanges;
  Future<void> sendPasswordResetEmail(String email);
  Future<void> updateProfile(UserProfile profile);
}
```

#### 2. Cashbook Management Service
Handles multi-cashbook organization with role-based permissions.

**Key Interfaces:**
```dart
@freezed
class Cashbook with _$Cashbook {
  const factory Cashbook({
    required String id,
    required String name,
    required CashbookType type,
    required String ownerId,
    required List<CashbookMember> members,
    required CashbookSettings settings,
    @Default(false) bool isArchived,
    required DateTime createdAt,
  }) = _Cashbook;
  
  factory Cashbook.fromJson(Map<String, dynamic> json) => _$CashbookFromJson(json);
}

@freezed
class CashbookMember with _$CashbookMember {
  const factory CashbookMember({
    required String userId,
    required CashbookRole role,
    required List<Permission> permissions,
    required DateTime joinedAt,
  }) = _CashbookMember;
  
  factory CashbookMember.fromJson(Map<String, dynamic> json) => _$CashbookMemberFromJson(json);
}

enum CashbookType { personal, business, family, group }
enum CashbookRole { owner, admin, member, viewer }

abstract class CashbookService {
  Future<Cashbook> createCashbook(String name, CashbookType type, CashbookSettings settings);
  Future<List<Cashbook>> getUserCashbooks(String userId);
  Future<void> inviteMember(String cashbookId, String email, CashbookRole role);
  Future<void> updateMemberRole(String cashbookId, String userId, CashbookRole role);
  Future<void> archiveCashbook(String cashbookId);
  Stream<List<Cashbook>> watchUserCashbooks(String userId);
}
```

#### 3. Account Management Service
Manages financial accounts with hierarchical structures and denomination tracking.

**Key Interfaces:**
```dart
@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required String cashbookId,
    required String name,
    required AccountType type,
    String? parentId,
    required double balance,
    required String currency,
    @Default(false) bool isArchived,
    AccountLimits? limits,
    BankConnection? bankConnection,
    DenominationTracking? denominationTracking,
    required AccountMetadata metadata,
  }) = _Account;
  
  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}

@freezed
class DenominationTracking with _$DenominationTracking {
  const factory DenominationTracking({
    @Default(true) bool enabled,
    required Map<String, int> denominations, // e.g., {"100": 5, "50": 3}
    required DateTime lastUpdated,
  }) = _DenominationTracking;
  
  factory DenominationTracking.fromJson(Map<String, dynamic> json) => _$DenominationTrackingFromJson(json);
}

enum AccountType { bank, wallet, cash, credit, investment, crypto }

abstract class AccountService {
  Future<Account> createAccount(String cashbookId, String name, AccountType type, String currency);
  Future<List<Account>> getCashbookAccounts(String cashbookId);
  Future<void> updateBalance(String accountId, double newBalance);
  Future<void> updateDenominations(String accountId, Map<String, int> denominations);
  Future<double> calculateHierarchicalBalance(String accountId);
  Stream<List<Account>> watchCashbookAccounts(String cashbookId);
}
```

#### 4. Transaction Management Service
Handles all financial transactions with comprehensive metadata and AI integration.

**Key Interfaces:**
```dart
@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String cashbookId,
    required double amount,
    required String currency,
    required DateTime date,
    required String accountId,
    required String categoryId,
    required String description,
    @Default([]) List<String> tags,
    GeoLocation? location,
    @Default([]) List<Attachment> attachments,
    List<TransactionSplit>? splits,
    MerchantInfo? merchantInfo,
    @Default(false) bool isRecurring,
    String? recurringId,
    required TransactionSource source,
    double? aiConfidence,
    @Default([]) List<AuditEntry> auditTrail,
    required TransactionMetadata metadata,
  }) = _Transaction;
  
  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}

@freezed
class TransactionSplit with _$TransactionSplit {
  const factory TransactionSplit({
    required double amount,
    required String categoryId,
    String? description,
  }) = _TransactionSplit;
  
  factory TransactionSplit.fromJson(Map<String, dynamic> json) => _$TransactionSplitFromJson(json);
}

enum TransactionSource { manual, voice, ai, bankSync, import }

abstract class TransactionService {
  Future<Transaction> createTransaction(CreateTransactionRequest request);
  Future<List<Transaction>> getTransactions(String cashbookId, TransactionFilter filter);
  Future<void> updateTransaction(String transactionId, UpdateTransactionRequest request);
  Future<void> deleteTransaction(String transactionId);
  Future<List<Transaction>> searchTransactions(String cashbookId, String query);
  Stream<List<Transaction>> watchTransactions(String cashbookId, TransactionFilter filter);
}
```

#### 5. AI Processing Service
Handles natural language processing and intelligent categorization using Firebase AI.

**Key Interfaces:**
```dart
@freezed
class NLPRequest with _$NLPRequest {
  const factory NLPRequest({
    required String text,
    required UserContext context,
    required String language,
  }) = _NLPRequest;
  
  factory NLPRequest.fromJson(Map<String, dynamic> json) => _$NLPRequestFromJson(json);
}

@freezed
class NLPResponse with _$NLPResponse {
  const factory NLPResponse({
    required PartialTransaction extractedTransaction,
    required double confidence,
    required List<CategorySuggestion> suggestedCategories,
  }) = _NLPResponse;
  
  factory NLPResponse.fromJson(Map<String, dynamic> json) => _$NLPResponseFromJson(json);
}

@freezed
class CategorySuggestion with _$CategorySuggestion {
  const factory CategorySuggestion({
    required String categoryId,
    required double confidence,
    required String reasoning,
  }) = _CategorySuggestion;
  
  factory CategorySuggestion.fromJson(Map<String, dynamic> json) => _$CategorySuggestionFromJson(json);
}

abstract class AIService {
  Future<NLPResponse> processNaturalLanguage(NLPRequest request);
  Future<List<CategorySuggestion>> suggestCategories(String description, double amount, String? location);
  Future<void> learnFromCorrection(String originalText, Transaction correctedTransaction);
  Future<String> processVoiceInput(String audioPath);
}
```

#### 6. Budget and Goals Service
Manages budgets and savings goals with intelligent tracking.

**Key Interfaces:**
```dart
@freezed
class Budget with _$Budget {
  const factory Budget({
    required String id,
    required String cashbookId,
    required String name,
    required BudgetType type,
    required BudgetPeriod period,
    required double amount,
    required String currency,
    List<String>? categories,
    List<String>? accounts,
    @Default(false) bool rolloverUnused,
    @Default([50, 75, 90, 100]) List<int> alertThresholds,
    @Default(true) bool isActive,
    required DateTime startDate,
    DateTime? endDate,
  }) = _Budget;
  
  factory Budget.fromJson(Map<String, dynamic> json) => _$BudgetFromJson(json);
}

@freezed
class SavingsGoal with _$SavingsGoal {
  const factory SavingsGoal({
    required String id,
    required String cashbookId,
    required String name,
    required double targetAmount,
    required String currency,
    DateTime? targetDate,
    @Default(0.0) double currentAmount,
    String? linkedAccountId,
    AutoContribution? autoContribution,
    @Default([]) List<GoalMilestone> milestones,
    @Default(true) bool isActive,
  }) = _SavingsGoal;
  
  factory SavingsGoal.fromJson(Map<String, dynamic> json) => _$SavingsGoalFromJson(json);
}

enum BudgetType { category, account, total }
enum BudgetPeriod { weekly, monthly, yearly, custom }

abstract class BudgetService {
  Future<Budget> createBudget(CreateBudgetRequest request);
  Future<List<Budget>> getCashbookBudgets(String cashbookId);
  Future<BudgetStatus> getBudgetStatus(String budgetId);
  Future<SavingsGoal> createSavingsGoal(CreateSavingsGoalRequest request);
  Future<List<SavingsGoal>> getCashbookGoals(String cashbookId);
  Stream<List<Budget>> watchCashbookBudgets(String cashbookId);
}
```

#### 7. Group Finance Service
Manages shared expenses and debt tracking between users.

**Key Interfaces:**
```dart
@freezed
class Group with _$Group {
  const factory Group({
    required String id,
    required String name,
    required List<GroupMember> members,
    @Default([]) List<GroupExpense> expenses,
    @Default([]) List<GroupBalance> balances,
  }) = _Group;
  
  factory Group.fromJson(Map<String, dynamic> json) => _$GroupFromJson(json);
}

@freezed
class GroupExpense with _$GroupExpense {
  const factory GroupExpense({
    required String id,
    required double amount,
    required String paidBy,
    required List<ExpenseSplit> splits,
    required ExpenseStatus status,
    required DateTime createdAt,
    String? description,
    @Default([]) List<Attachment> attachments,
  }) = _GroupExpense;
  
  factory GroupExpense.fromJson(Map<String, dynamic> json) => _$GroupExpenseFromJson(json);
}

@freezed
class ExpenseSplit with _$ExpenseSplit {
  const factory ExpenseSplit({
    required String userId,
    required double amount,
    @Default(false) bool settled,
    DateTime? settledAt,
  }) = _ExpenseSplit;
  
  factory ExpenseSplit.fromJson(Map<String, dynamic> json) => _$ExpenseSplitFromJson(json);
}

enum ExpenseStatus { pending, settled, disputed }

abstract class GroupService {
  Future<Group> createGroup(String name, List<String> memberEmails);
  Future<GroupExpense> addGroupExpense(String groupId, CreateGroupExpenseRequest request);
  Future<void> settleExpense(String expenseId, SettlementType settlementType);
  Future<List<GroupBalance>> getGroupBalances(String groupId);
  Future<List<Group>> getUserGroups(String userId);
  Stream<Group> watchGroup(String groupId);
}
```

#### 8. Loan Management Service
Manages personal lending and borrowing with flexible settlement options.

**Key Interfaces:**
```dart
@freezed
class Loan with _$Loan {
  const factory Loan({
    required String id,
    required String cashbookId,
    required LoanType type,
    String? counterpartyId,
    required String counterpartyName,
    required double principalAmount,
    required String currency,
    double? interestRate,
    InterestType? interestType,
    DateTime? dueDate,
    required LoanStatus status,
    @Default([]) List<LoanPayment> payments,
    String? agreementDocument,
    required DateTime createdAt,
    DateTime? settledAt,
  }) = _Loan;
  
  factory Loan.fromJson(Map<String, dynamic> json) => _$LoanFromJson(json);
}

@freezed
class LoanPayment with _$LoanPayment {
  const factory LoanPayment({
    required String id,
    required double amount,
    required DateTime date,
    required PaymentType type,
    String? transactionId,
    String? notes,
  }) = _LoanPayment;
  
  factory LoanPayment.fromJson(Map<String, dynamic> json) => _$LoanPaymentFromJson(json);
}

enum LoanType { lent, borrowed }
enum LoanStatus { active, settled, overdue }
enum PaymentType { principal, interest, partial }

@freezed
class SettlementType with _$SettlementType {
  const factory SettlementType.collect({
    required double amount,
  }) = _SettlementCollect;
  
  const factory SettlementType.lendAgain({
    required double amount,
    required Loan newLoanTerms,
  }) = _SettlementLendAgain;
  
  const factory SettlementType.settle() = _SettlementSettle;
}

abstract class LoanService {
  Future<Loan> createLoan(CreateLoanRequest request);
  Future<void> recordPayment(String loanId, LoanPayment payment);
  Future<void> settleLoan(String loanId, SettlementType settlementType);
  Future<double> calculateInterest(String loanId);
  Future<List<Loan>> getOverdueLoans(String userId);
  Stream<List<Loan>> watchCashbookLoans(String cashbookId);
}
```

#### 9. Subscription Management Service
Tracks recurring expenses and subscription optimization.

**Key Interfaces:**
```dart
@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    required String cashbookId,
    required String serviceName,
    required String provider,
    required double amount,
    required String currency,
    required BillingCycle billingCycle,
    required DateTime nextBillingDate,
    DateTime? trialEndDate,
    String? cancellationUrl,
    required SubscriptionStatus status,
    UsageTracking? usageTracking,
    required String recurringTransactionId,
    @Default([]) List<PriceChange> priceHistory,
  }) = _Subscription;
  
  factory Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);
}

@freezed
class OptimizationSuggestion with _$OptimizationSuggestion {
  const factory OptimizationSuggestion({
    required String subscriptionId,
    required OptimizationType type,
    required double potentialSavings,
    required String reasoning,
    String? actionUrl,
  }) = _OptimizationSuggestion;
  
  factory OptimizationSuggestion.fromJson(Map<String, dynamic> json) => _$OptimizationSuggestionFromJson(json);
}

enum BillingCycle { weekly, monthly, quarterly, yearly }
enum SubscriptionStatus { active, cancelled, paused, trial }
enum OptimizationType { downgrade, cancel, alternative }

abstract class SubscriptionService {
  Future<List<RecurringPattern>> detectRecurringPatterns(List<Transaction> transactions);
  Future<List<PriceChange>> trackPriceChanges(String subscriptionId);
  Future<List<OptimizationSuggestion>> suggestOptimizations(String userId);
  Future<CancellationInfo> manageCancellations(String subscriptionId);
  Stream<List<Subscription>> watchCashbookSubscriptions(String cashbookId);
}
```

#### 10. Analytics and Reporting Service
Provides comprehensive financial insights and customizable reports.

**Key Interfaces:**
```dart
@freezed
class AnalyticsQuery with _$AnalyticsQuery {
  const factory AnalyticsQuery({
    required DateRange dateRange,
    required List<String> cashbookIds,
    List<String>? categories,
    List<String>? accounts,
    required List<GroupByField> groupBy,
    required List<AnalyticsMetric> metrics,
  }) = _AnalyticsQuery;
  
  factory AnalyticsQuery.fromJson(Map<String, dynamic> json) => _$AnalyticsQueryFromJson(json);
}

@freezed
class FinancialInsight with _$FinancialInsight {
  const factory FinancialInsight({
    required InsightType type,
    required String title,
    required String description,
    required ImpactLevel impact,
    @Default(false) bool actionable,
    @Default([]) List<String> recommendations,
    required InsightData data,
  }) = _FinancialInsight;
  
  factory FinancialInsight.fromJson(Map<String, dynamic> json) => _$FinancialInsightFromJson(json);
}

enum InsightType { spending, saving, budget, goal, trend }
enum ImpactLevel { low, medium, high, critical }

abstract class AnalyticsService {
  Future<AnalyticsResult> runQuery(AnalyticsQuery query);
  Future<List<FinancialInsight>> generateInsights(String cashbookId, DateRange dateRange);
  Future<SpendingForecast> generateSpendingForecast(String cashbookId);
  Future<ExportResult> exportData(ExportRequest request);
  Stream<List<FinancialInsight>> watchInsights(String cashbookId);
}
```

### Data Flow Architecture

#### Transaction Processing Flow
1. **User Input**: Voice, text, or manual entry through Flutter UI
2. **Local Storage**: Immediate storage in Hive for offline capability
3. **AI Processing**: Firebase AI Logic processes natural language (if applicable)
4. **Validation**: Client-side validation with Riverpod providers
5. **Firebase Sync**: Background sync to Firestore with conflict resolution
6. **Real-time Updates**: Firestore listeners update all connected devices
7. **Analytics Update**: Background functions update insights and reports

#### Offline-First Synchronization
1. **Local Changes**: All operations stored locally in Hive first
2. **Change Queue**: Pending changes queued for synchronization
3. **Background Sync**: Automatic sync when connection available
4. **Conflict Resolution**: Last-write-wins with user notification for conflicts
5. **Delta Sync**: Only changed data transmitted to minimize bandwidth

## Comprehensive Utilities and Assets Architecture

### Utility Classes and Helper Functions

The utility system provides comprehensive helper functions for common operations:

```dart
// Core utilities
class AppConstants {
  static const String appName = 'Cashense';
  static const String appVersion = '1.0.0';
  static const Duration defaultTimeout = Duration(seconds: 30);
  static const int maxRetryAttempts = 3;
  
  // Currency constants
  static const List<String> supportedCurrencies = [
    'USD', 'EUR', 'GBP', 'JPY', 'INR', 'CNY', 'AUD', 'CAD'
  ];
  
  // Date formats
  static const String defaultDateFormat = 'yyyy-MM-dd';
  static const String displayDateFormat = 'MMM dd, yyyy';
  static const String timeFormat = 'HH:mm';
}

class ValidationUtils {
  static bool isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }
  
  static bool isValidAmount(String amount) {
    return RegExp(r'^\d+(\.\d{1,2})?$').hasMatch(amount);
  }
  
  static bool isValidPhoneNumber(String phone) {
    return RegExp(r'^\+?[\d\s\-\(\)]{10,}$').hasMatch(phone);
  }
  
  static String? validateRequired(String? value, String fieldName) {
    if (value == null || value.trim().isEmpty) {
      return '$fieldName is required';
    }
    return null;
  }
}

class FormatterUtils {
  static String formatCurrency(double amount, String currencyCode) {
    final formatter = NumberFormat.currency(symbol: getCurrencySymbol(currencyCode));
    return formatter.format(amount);
  }
  
  static String formatPercentage(double value) {
    return '${(value * 100).toStringAsFixed(1)}%';
  }
  
  static String formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
  
  static String formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);
    
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    if (difference.inMinutes > 0) return '${difference.inMinutes}m ago';
    return 'Just now';
  }
}

class CryptoUtils {
  static String generateSecureId() {
    final random = Random.secure();
    final bytes = List<int>.generate(16, (i) => random.nextInt(256));
    return base64Url.encode(bytes);
  }
  
  static String hashPassword(String password, String salt) {
    final bytes = utf8.encode(password + salt);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
  
  static String generateSalt() {
    final random = Random.secure();
    final bytes = List<int>.generate(32, (i) => random.nextInt(256));
    return base64.encode(bytes);
  }
}
```

### Assets Management System

Comprehensive asset organization with optimization and caching:

```
assets/
├── images/                           # Image assets
│   ├── icons/                        # App icons
│   │   ├── app_icon.png
│   │   ├── app_icon_adaptive.png
│   │   └── splash_icon.png
│   ├── illustrations/                # Onboarding and empty states
│   │   ├── onboarding_1.svg
│   │   ├── onboarding_2.svg
│   │   ├── empty_transactions.svg
│   │   └── empty_budget.svg
│   ├── categories/                   # Category icons
│   │   ├── food.svg
│   │   ├── transport.svg
│   │   ├── entertainment.svg
│   │   └── [other categories]/
│   └── currencies/                   # Currency flags/symbols
│       ├── usd.png
│       ├── eur.png
│       └── [other currencies]/
├── fonts/                           # Custom fonts
│   ├── Roboto/
│   │   ├── Roboto-Regular.ttf
│   │   ├── Roboto-Bold.ttf
│   │   └── Roboto-Light.ttf
│   └── Inter/
│       ├── Inter-Regular.ttf
│       ├── Inter-SemiBold.ttf
│       └── Inter-Bold.ttf
├── animations/                      # Lottie animations
│   ├── loading.json
│   ├── success.json
│   ├── error.json
│   └── empty_state.json
└── data/                           # Static data files
    ├── currencies.json
    ├── countries.json
    ├── categories.json
    └── exchange_rates_fallback.json
```

### Asset Management Service

```dart
class AssetService {
  static const String _basePath = 'assets';
  
  // Image assets
  static String getImagePath(String imageName) => '$_basePath/images/$imageName';
  static String getIconPath(String iconName) => '$_basePath/images/icons/$iconName';
  static String getCategoryIconPath(String category) => '$_basePath/images/categories/$category.svg';
  static String getCurrencyFlagPath(String currencyCode) => '$_basePath/images/currencies/${currencyCode.toLowerCase()}.png';
  
  // Animation assets
  static String getAnimationPath(String animationName) => '$_basePath/animations/$animationName.json';
  
  // Data assets
  static Future<Map<String, dynamic>> loadJsonAsset(String fileName) async {
    final jsonString = await rootBundle.loadString('$_basePath/data/$fileName');
    return json.decode(jsonString);
  }
  
  // Font assets
  static const String primaryFont = 'Inter';
  static const String secondaryFont = 'Roboto';
  
  // Asset preloading for performance
  static Future<void> preloadCriticalAssets(BuildContext context) async {
    final imagesToPreload = [
      'icons/app_icon.png',
      'illustrations/empty_transactions.svg',
      'illustrations/empty_budget.svg',
    ];
    
    for (final imagePath in imagesToPreload) {
      await precacheImage(AssetImage(getImagePath(imagePath)), context);
    }
  }
}
```

### Performance Optimization Utilities

```dart
class PerformanceUtils {
  static Timer? _debounceTimer;
  
  static void debounce(Duration duration, VoidCallback callback) {
    _debounceTimer?.cancel();
    _debounceTimer = Timer(duration, callback);
  }
  
  static Future<T> throttle<T>(
    Duration duration,
    Future<T> Function() operation,
  ) async {
    await Future.delayed(duration);
    return operation();
  }
  
  static Widget buildOptimizedList<T>({
    required List<T> items,
    required Widget Function(BuildContext, T) itemBuilder,
    int? itemCount,
  }) {
    return ListView.builder(
      itemCount: itemCount ?? items.length,
      itemBuilder: (context, index) {
        if (index >= items.length) return const SizedBox.shrink();
        return itemBuilder(context, items[index]);
      },
    );
  }
}

class CacheManager {
  static final Map<String, dynamic> _cache = {};
  static const Duration defaultCacheExpiry = Duration(hours: 1);
  
  static void set<T>(String key, T value, {Duration? expiry}) {
    _cache[key] = CacheEntry(
      value: value,
      expiry: DateTime.now().add(expiry ?? defaultCacheExpiry),
    );
  }
  
  static T? get<T>(String key) {
    final entry = _cache[key] as CacheEntry<T>?;
    if (entry == null || entry.isExpired) {
      _cache.remove(key);
      return null;
    }
    return entry.value;
  }
  
  static void clear() => _cache.clear();
  static void remove(String key) => _cache.remove(key);
}

class CacheEntry<T> {
  final T value;
  final DateTime expiry;
  
  CacheEntry({required this.value, required this.expiry});
  
  bool get isExpired => DateTime.now().isAfter(expiry);
}
```

## Data Models

### Core Data Models with Freezed

All data models use Freezed for immutability and code generation:

#### User Management Models
```dart
@freezed
class User with _$User {
  const factory User({
    required String id,
    required String email,
    String? displayName,
    String? photoURL,
    required UserProfile profile,
    required UserPreferences preferences,
    required SecuritySettings securitySettings,
    required DateTime createdAt,
    DateTime? lastLoginAt,
  }) = _User;
  
  factory User.fromJson(Map<String, dynamic> json) => _$UserFromJson(json);
}

@freezed
class UserPreferences with _$UserPreferences {
  const factory UserPreferences({
    required String defaultCurrency,
    required String dateFormat,
    required String numberFormat,
    @Default(true) bool enableNotifications,
    @Default(true) bool enableVoiceInput,
    @Default(false) bool enableBiometric,
    required ThemeConfig theme,
    required List<QuickAction> quickActions,
  }) = _UserPreferences;
  
  factory UserPreferences.fromJson(Map<String, dynamic> json) => _$UserPreferencesFromJson(json);
}
```

#### Financial Data Models
```dart
@freezed
class Account with _$Account {
  const factory Account({
    required String id,
    required String cashbookId,
    required String name,
    required AccountType type,
    String? parentId,
    required double balance,
    required String currency,
    @Default(false) bool isArchived,
    AccountLimits? limits,
    BankConnection? bankConnection,
    DenominationTracking? denominationTracking,
    required AccountMetadata metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Account;
  
  factory Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);
}

@freezed
class Transaction with _$Transaction {
  const factory Transaction({
    required String id,
    required String cashbookId,
    required double amount,
    required String currency,
    required DateTime date,
    required String accountId,
    required String categoryId,
    required String description,
    @Default([]) List<String> tags,
    GeoLocation? location,
    @Default([]) List<Attachment> attachments,
    List<TransactionSplit>? splits,
    MerchantInfo? merchantInfo,
    @Default(false) bool isRecurring,
    String? recurringId,
    required TransactionSource source,
    double? aiConfidence,
    @Default([]) List<AuditEntry> auditTrail,
    required TransactionMetadata metadata,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Transaction;
  
  factory Transaction.fromJson(Map<String, dynamic> json) => _$TransactionFromJson(json);
}
```

### Hive Storage Models

For local storage, simplified models are used with Hive:

```dart
@HiveType(typeId: 0)
class LocalTransaction extends HiveObject {
  @HiveField(0)
  late String id;
  
  @HiveField(1)
  late String cashbookId;
  
  @HiveField(2)
  late double amount;
  
  @HiveField(3)
  late String currency;
  
  @HiveField(4)
  late DateTime date;
  
  @HiveField(5)
  late String accountId;
  
  @HiveField(6)
  late String categoryId;
  
  @HiveField(7)
  late String description;
  
  @HiveField(8)
  late bool synced;
  
  @HiveField(9)
  late DateTime lastModified;
}
```

## Error Handling

### Error Categories and Strategies

#### 1. Network and Connectivity Errors
- **Offline Mode**: Full functionality with Hive local storage
- **Sync Conflicts**: User-guided resolution with merge options
- **Firebase Failures**: Exponential backoff with circuit breaker pattern
- **Timeout Handling**: Progressive timeout with user feedback

```dart
@freezed
class AppError with _$AppError {
  const factory AppError.network({
    required String message,
    String? code,
    @Default(false) bool isRetryable,
  }) = NetworkError;
  
  const factory AppError.validation({
    required String field,
    required String message,
  }) = ValidationError;
  
  const factory AppError.permission({
    required String message,
    required String requiredPermission,
  }) = PermissionError;
  
  const factory AppError.ai({
    required String message,
    @Default(false) bool canFallback,
  }) = AIError;
}
```

#### 2. Error Recovery with Riverpod
```dart
final errorHandlerProvider = Provider<ErrorHandler>((ref) {
  return ErrorHandler(
    onNetworkError: (error) async {
      // Show offline banner
      // Queue for retry
      // Switch to offline mode
    },
    onValidationError: (error) async {
      // Show field-specific error
      // Highlight invalid fields
    },
    onPermissionError: (error) async {
      // Show permission dialog
      // Redirect to settings
    },
  );
});
```

## Testing Strategy

### Testing Pyramid with Flutter

#### 1. Unit Testing (70%)
- **Service Testing**: Individual service and provider validation
- **Business Logic**: Core financial calculations and rules
- **Data Models**: Freezed model validation and serialization
- **Utility Functions**: Helper functions and algorithms
- **AI Components**: NLP parsing and categorization accuracy

```dart
void main() {
  group('TransactionService', () {
    late TransactionService service;
    late MockFirestore mockFirestore;
    
    setUp(() {
      mockFirestore = MockFirestore();
      service = TransactionService(mockFirestore);
    });
    
    test('should create transaction with valid data', () async {
      // Arrange
      final request = CreateTransactionRequest(
        amount: 100.0,
        description: 'Test transaction',
        categoryId: 'category1',
        accountId: 'account1',
      );
      
      // Act
      final result = await service.createTransaction(request);
      
      // Assert
      expect(result.amount, equals(100.0));
      expect(result.description, equals('Test transaction'));
    });
  });
}
```

#### 2. Widget Testing (20%)
- **Screen Testing**: Individual screen functionality
- **Component Testing**: Reusable widget components
- **Form Testing**: Input validation and submission
- **Navigation Testing**: Route handling and deep links

```dart
void main() {
  group('TransactionForm', () {
    testWidgets('should validate required fields', (tester) async {
      // Arrange
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: TransactionForm(),
          ),
        ),
      );
      
      // Act
      await tester.tap(find.byType(ElevatedButton));
      await tester.pump();
      
      // Assert
      expect(find.text('Amount is required'), findsOneWidget);
    });
  });
}
```

#### 3. Integration Testing (10%)
- **End-to-End Workflows**: Complete user scenarios
- **Firebase Integration**: Real Firebase service testing
- **Cross-Platform**: Testing across mobile, web, desktop
- **Performance**: Load testing and memory usage

```dart
void main() {
  group('Transaction Flow Integration', () {
    testWidgets('should create and sync transaction', (tester) async {
      // Setup test environment
      await Firebase.initializeApp();
      
      // Test complete flow
      await tester.pumpWidget(MyApp());
      
      // Navigate to add transaction
      await tester.tap(find.byIcon(Icons.add));
      await tester.pumpAndSettle();
      
      // Fill form
      await tester.enterText(find.byKey(Key('amount')), '50.00');
      await tester.enterText(find.byKey(Key('description')), 'Coffee');
      
      // Submit
      await tester.tap(find.text('Save'));
      await tester.pumpAndSettle();
      
      // Verify transaction appears in list
      expect(find.text('Coffee'), findsOneWidget);
      expect(find.text('\$50.00'), findsOneWidget);
    });
  });
}
```

### Test Data Management

```dart
class TestDataFactory {
  static User createTestUser({String? id}) {
    return User(
      id: id ?? 'test_user_1',
      email: 'test@example.com',
      profile: UserProfile(
        firstName: 'Test',
        lastName: 'User',
        timezone: 'UTC',
        language: 'en',
        currency: 'USD',
      ),
      preferences: UserPreferences(
        defaultCurrency: 'USD',
        dateFormat: 'MM/dd/yyyy',
        numberFormat: 'en_US',
        theme: ThemeConfig.light(),
        quickActions: [],
      ),
      securitySettings: SecuritySettings(
        twoFactorEnabled: false,
        biometricEnabled: false,
        sessionTimeout: 30,
        privacyMode: false,
      ),
      createdAt: DateTime.now(),
    );
  }
  
  static Transaction createTestTransaction({
    String? id,
    required String cashbookId,
    required String accountId,
  }) {
    return Transaction(
      id: id ?? 'test_transaction_1',
      cashbookId: cashbookId,
      amount: 100.0,
      currency: 'USD',
      date: DateTime.now(),
      accountId: accountId,
      categoryId: 'food',
      description: 'Test transaction',
      source: TransactionSource.manual,
      metadata: TransactionMetadata(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }
}
```

## Security Architecture

### Security Layers

#### 1. Firebase Security Rules
```javascript
rules_version = '2';
service cloud.firestore {
  match /databases/{database}/documents {
    // Users can only access their own data
    match /users/{userId} {
      allow read, write: if request.auth != null && request.auth.uid == userId;
    }
    
    // Cashbook access based on membership
    match /cashbooks/{cashbookId} {
      allow read, write: if request.auth != null && 
        request.auth.uid in resource.data.memberIds;
    }
    
    // Transactions within cashbook
    match /cashbooks/{cashbookId}/transactions/{transactionId} {
      allow read, write: if request.auth != null && 
        exists(/databases/$(database)/documents/cashbooks/$(cashbookId)) &&
        request.auth.uid in get(/databases/$(database)/documents/cashbooks/$(cashbookId)).data.memberIds;
    }
  }
}
```

#### 2. Client-Side Security
```dart
class SecurityService {
  static const _secureStorage = FlutterSecureStorage(
    aOptions: AndroidOptions(
      encryptedSharedPreferences: true,
    ),
    iOptions: IOSOptions(
      accessibility: IOSAccessibility.first_unlock_this_device,
    ),
  );
  
  Future<void> storeSecureData(String key, String value) async {
    await _secureStorage.write(key: key, value: value);
  }
  
  Future<String?> getSecureData(String key) async {
    return await _secureStorage.read(key: key);
  }
  
  Future<bool> authenticateWithBiometrics() async {
    final localAuth = LocalAuthentication();
    
    try {
      final bool didAuthenticate = await localAuth.authenticate(
        localizedFallbackTitle: 'Please authenticate to access your financial data',
        biometricOnly: true,
      );
      return didAuthenticate;
    } catch (e) {
      return false;
    }
  }
}
```

#### 3. Data Encryption
```dart
class EncryptionService {
  static const _key = 'your-encryption-key';
  
  static String encryptSensitiveData(String data) {
    final key = encrypt.Key.fromSecureRandom(32);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    
    final encrypted = encrypter.encrypt(data, iv: iv);
    return encrypted.base64;
  }
  
  static String decryptSensitiveData(String encryptedData) {
    final key = encrypt.Key.fromSecureRandom(32);
    final iv = encrypt.IV.fromSecureRandom(16);
    final encrypter = encrypt.Encrypter(encrypt.AES(key));
    
    final encrypted = encrypt.Encrypted.fromBase64(encryptedData);
    return encrypter.decrypt(encrypted, iv: iv);
  }
}
```

## Performance Optimization

### Performance Targets
- **App Launch**: < 2 seconds cold start
- **Transaction Entry**: < 500ms response time
- **Sync Operations**: < 5 seconds for delta sync
- **Report Generation**: < 3 seconds for standard reports
- **Offline Performance**: No degradation in core features

### Optimization Strategies

#### 1. Flutter Performance
```dart
// Efficient list rendering with ListView.builder
class TransactionList extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final transactions = ref.watch(transactionsProvider);
    
    return transactions.when(
      data: (data) => ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          return TransactionTile(
            key: ValueKey(data[index].id),
            transaction: data[index],
          );
        },
      ),
      loading: () => const CircularProgressIndicator(),
      error: (error, stack) => ErrorWidget(error),
    );
  }
}

// Optimized image loading
class OptimizedImage extends StatelessWidget {
  final String imageUrl;
  
  const OptimizedImage({Key? key, required this.imageUrl}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl,
      placeholder: (context, url) => const CircularProgressIndicator(),
      errorWidget: (context, url, error) => const Icon(Icons.error),
      memCacheWidth: 300,
      memCacheHeight: 300,
    );
  }
}
```

#### 2. Firebase Optimization
```dart
// Efficient Firestore queries with pagination
class TransactionRepository {
  static const int _pageSize = 20;
  
  Future<List<Transaction>> getTransactions({
    required String cashbookId,
    DocumentSnapshot? startAfter,
  }) async {
    Query query = FirebaseFirestore.instance
        .collection('cashbooks')
        .doc(cashbookId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .limit(_pageSize);
    
    if (startAfter != null) {
      query = query.startAfterDocument(startAfter);
    }
    
    final snapshot = await query.get();
    return snapshot.docs
        .map((doc) => Transaction.fromJson(doc.data() as Map<String, dynamic>))
        .toList();
  }
}

// Optimized real-time listeners
final transactionsProvider = StreamProvider.family<List<Transaction>, String>(
  (ref, cashbookId) {
    return FirebaseFirestore.instance
        .collection('cashbooks')
        .doc(cashbookId)
        .collection('transactions')
        .orderBy('date', descending: true)
        .limit(50) // Limit initial load
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Transaction.fromJson(doc.data()))
            .toList());
  },
);
```

#### 3. Local Storage Optimization
```dart
// Efficient Hive operations
class LocalTransactionRepository {
  static const String _boxName = 'transactions';
  late Box<LocalTransaction> _box;
  
  Future<void> init() async {
    Hive.registerAdapter(LocalTransactionAdapter());
    _box = await Hive.openBox<LocalTransaction>(_boxName);
  }
  
  Future<void> saveTransaction(LocalTransaction transaction) async {
    await _box.put(transaction.id, transaction);
  }
  
  List<LocalTransaction> getTransactions({
    required String cashbookId,
    int limit = 50,
  }) {
    return _box.values
        .where((t) => t.cashbookId == cashbookId)
        .take(limit)
        .toList();
  }
  
  Future<void> clearSyncedTransactions() async {
    final syncedKeys = _box.values
        .where((t) => t.synced)
        .map((t) => t.key)
        .toList();
    
    await _box.deleteAll(syncedKeys);
  }
}
```

## Deployment and DevOps

### Deployment Architecture

#### 1. Firebase Hosting Configuration
```yaml
# firebase.json
{
  "hosting": {
    "public": "build/web",
    "ignore": [
      "firebase.json",
      "**/.*",
      "**/node_modules/**"
    ],
    "rewrites": [
      {
        "source": "**",
        "destination": "/index.html"
      }
    ],
    "headers": [
      {
        "source": "**/*.@(js|css)",
        "headers": [
          {
            "key": "Cache-Control",
            "value": "max-age=31536000"
          }
        ]
      }
    ]
  },
  "functions": {
    "source": "functions",
    "runtime": "nodejs18"
  },
  "firestore": {
    "rules": "firestore.rules",
    "indexes": "firestore.indexes.json"
  },
  "storage": {
    "rules": "storage.rules"
  }
}
```

#### 2. GitHub Actions CI/CD
```yaml
# .github/workflows/deploy.yml
name: Deploy to Firebase

on:
  push:
    branches: [ main ]
  pull_request:
    branches: [ main ]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    - run: flutter pub get
    - run: flutter test
    - run: flutter analyze

  build-web:
    needs: test
    runs-on: ubuntu-latest
    steps:
    - uses: actions/checkout@v3
    - uses: subosito/flutter-action@v2
      with:
        flutter-version: '3.16.0'
    - run: flutter pub get
    - run: flutter build web --release
    - uses: actions/upload-artifact@v3
      with:
        name: web-build
        path: build/web/

  deploy:
    needs: build-web
    runs-on: ubuntu-latest
    if: github.ref == 'refs/heads/main'
    steps:
    - uses: actions/checkout@v3
    - uses: actions/download-artifact@v3
      with:
        name: web-build
        path: build/web/
    - uses: FirebaseExtended/action-hosting-deploy@v0
      with:
        repoToken: '${{ secrets.GITHUB_TOKEN }}'
        firebaseServiceAccount: '${{ secrets.FIREBASE_SERVICE_ACCOUNT }}'
        projectId: cashense-app
```

#### 3. Environment Management
```dart
// lib/config/environment.dart
enum Environment { development, staging, production }

class AppConfig {
  static Environment get environment {
    const env = String.fromEnvironment('ENVIRONMENT', defaultValue: 'development');
    switch (env) {
      case 'production':
        return Environment.production;
      case 'staging':
        return Environment.staging;
      default:
        return Environment.development;
    }
  }
  
  static String get firebaseProjectId {
    switch (environment) {
      case Environment.production:
        return 'cashense-prod';
      case Environment.staging:
        return 'cashense-staging';
      case Environment.development:
        return 'cashense-dev';
    }
  }
  
  static String get openAIApiKey {
    return const String.fromEnvironment('OPENAI_API_KEY');
  }
}
```

### Scalability Considerations

#### 1. Firebase Scaling Strategy
```dart
// Firestore composite indexes for efficient queries
// firestore.indexes.json
{
  "indexes": [
    {
      "collectionGroup": "transactions",
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "cashbookId", "order": "ASCENDING"},
        {"fieldPath": "date", "order": "DESCENDING"}
      ]
    },
    {
      "collectionGroup": "transactions",
      "queryScope": "COLLECTION",
      "fields": [
        {"fieldPath": "cashbookId", "order": "ASCENDING"},
        {"fieldPath": "categoryId", "order": "ASCENDING"},
        {"fieldPath": "date", "order": "DESCENDING"}
      ]
    }
  ]
}
```

#### 2. Cost Monitoring
```dart
// Firebase Functions for cost monitoring
exports.monitorUsage = functions.pubsub
  .schedule('every 24 hours')
  .onRun(async (context) => {
    const usage = await admin.firestore().collection('usage').get();
    const dailyReads = usage.docs.length;
    
    if (dailyReads > 45000) { // 90% of free tier
      await admin.messaging().send({
        topic: 'admin',
        notification: {
          title: 'High Firestore Usage',
          body: `Daily reads: ${dailyReads}/50000`
        }
      });
    }
  });
```

This comprehensive design document provides a complete technical blueprint for building Cashense using your preferred Firebase-focused, cost-effective Flutter stack while addressing all functional requirements from the requirements document.