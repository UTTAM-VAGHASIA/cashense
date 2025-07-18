# Cashense API Documentation

This document provides comprehensive API documentation for Cashense services and interfaces. Cashense is an AI-powered, cross-platform financial management application that serves as the ultimate financial companion for individuals and groups.

## 📋 Table of Contents

- [Authentication API](#authentication-api)
- [Cashbook Management API](#cashbook-management-api)
- [Account Management API](#account-management-api)
- [Transaction Management API](#transaction-management-api)
- [Budget Management API](#budget-management-api)
- [AI Services API](#ai-services-api)
- [Analytics API](#analytics-api)
- [Group Finance API](#group-finance-api)
- [Loan Management API](#loan-management-api)
- [Data Models](#data-models)
- [Error Handling](#error-handling)

## 🔐 Authentication API

### AuthService

The `AuthService` handles all authentication operations using Firebase Authentication.

#### Methods

##### `signInWithEmail(String email, String password)`

Signs in a user with email and password.

**Parameters:**
- `email` (String): User's email address
- `password` (String): User's password

**Returns:** `Future<Result<User>>`

**Example:**
```dart
final authService = ref.read(authServiceProvider);
final result = await authService.signInWithEmail('user@example.com', 'password123');

result.when(
  success: (user) => print('Signed in: ${user.email}'),
  failure: (error) => print('Sign in failed: $error'),
);
```

##### `signUpWithEmail(String email, String password, UserProfile profile)`

Creates a new user account with email and password.

**Parameters:**
- `email` (String): User's email address
- `password` (String): User's password
- `profile` (UserProfile): User profile information

**Returns:** `Future<Result<User>>`

**Example:**
```dart
final profile = UserProfile(
  firstName: 'John',
  lastName: 'Doe',
  timezone: 'America/New_York',
  language: 'en',
  currency: 'USD',
);

final result = await authService.signUpWithEmail(
  'john@example.com',
  'securePassword123',
  profile,
);
```

##### `signInWithGoogle()`

Signs in a user using Google OAuth.

**Returns:** `Future<Result<User>>`

##### `signOut()`

Signs out the current user.

**Returns:** `Future<void>`

##### `sendPasswordResetEmail(String email)`

Sends a password reset email to the user.

**Parameters:**
- `email` (String): User's email address

**Returns:** `Future<Result<void>>`

##### `updateProfile(UserProfile profile)`

Updates the current user's profile information.

**Parameters:**
- `profile` (UserProfile): Updated profile information

**Returns:** `Future<Result<void>>`

#### Streams

##### `authStateChanges`

Stream of authentication state changes.

**Returns:** `Stream<User?>`

**Example:**
```dart
final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
```

## 📚 Cashbook Management API

### CashbookService

Manages multiple cashbooks with role-based permissions.

#### Methods

##### `createCashbook(String name, CashbookType type, CashbookSettings settings)`

Creates a new cashbook.

**Parameters:**
- `name` (String): Cashbook name
- `type` (CashbookType): Type of cashbook (personal, business, family, group)
- `settings` (CashbookSettings): Cashbook configuration

**Returns:** `Future<Result<Cashbook>>`

**Example:**
```dart
final settings = CashbookSettings(
  defaultCurrency: 'USD',
  allowNegativeBalances: false,
  requireApprovalForExpenses: true,
);

final result = await cashbookService.createCashbook(
  'Personal Finance',
  CashbookType.personal,
  settings,
);
```

##### `getUserCashbooks(String userId)`

Retrieves all cashbooks for a user.

**Parameters:**
- `userId` (String): User ID

**Returns:** `Future<Result<List<Cashbook>>>`

##### `inviteMember(String cashbookId, String email, CashbookRole role)`

Invites a new member to a cashbook.

**Parameters:**
- `cashbookId` (String): Cashbook ID
- `email` (String): Invitee's email
- `role` (CashbookRole): Member role (owner, admin, member, viewer)

**Returns:** `Future<Result<void>>`

##### `updateMemberRole(String cashbookId, String userId, CashbookRole role)`

Updates a member's role in a cashbook.

**Parameters:**
- `cashbookId` (String): Cashbook ID
- `userId` (String): Member's user ID
- `role` (CashbookRole): New role

**Returns:** `Future<Result<void>>`

##### `archiveCashbook(String cashbookId)`

Archives a cashbook (soft delete).

**Parameters:**
- `cashbookId` (String): Cashbook ID

**Returns:** `Future<Result<void>>`

#### Streams

##### `watchUserCashbooks(String userId)`

Stream of user's cashbooks with real-time updates.

**Parameters:**
- `userId` (String): User ID

**Returns:** `Stream<List<Cashbook>>`

## 💰 Account Management API

### AccountService

Manages financial accounts with hierarchical structures.

#### Methods

##### `createAccount(String cashbookId, String name, AccountType type, String currency)`

Creates a new financial account.

**Parameters:**
- `cashbookId` (String): Parent cashbook ID
- `name` (String): Account name
- `type` (AccountType): Account type (bank, wallet, cash, credit, investment, crypto)
- `currency` (String): Account currency code

**Returns:** `Future<Result<Account>>`

**Example:**
```dart
final result = await accountService.createAccount(
  'cashbook123',
  'Chase Checking',
  AccountType.bank,
  'USD',
);
```

##### `getCashbookAccounts(String cashbookId)`

Retrieves all accounts for a cashbook.

**Parameters:**
- `cashbookId` (String): Cashbook ID

**Returns:** `Future<Result<List<Account>>>`

##### `updateBalance(String accountId, double newBalance)`

Updates an account's balance.

**Parameters:**
- `accountId` (String): Account ID
- `newBalance` (double): New balance amount

**Returns:** `Future<Result<void>>`

##### `updateDenominations(String accountId, Map<String, int> denominations)`

Updates cash denominations for cash accounts.

**Parameters:**
- `accountId` (String): Account ID
- `denominations` (Map<String, int>): Denomination counts (e.g., {"100": 5, "50": 3})

**Returns:** `Future<Result<void>>`

**Example:**
```dart
final denominations = {
  '100': 5,  // 5 x $100 bills
  '50': 3,   // 3 x $50 bills
  '20': 10,  // 10 x $20 bills
  '10': 15,  // 15 x $10 bills
};

await accountService.updateDenominations('account123', denominations);
```

##### `calculateHierarchicalBalance(String accountId)`

Calculates total balance including all sub-accounts.

**Parameters:**
- `accountId` (String): Parent account ID

**Returns:** `Future<Result<double>>`

#### Streams

##### `watchCashbookAccounts(String cashbookId)`

Stream of accounts with real-time updates.

**Parameters:**
- `cashbookId` (String): Cashbook ID

**Returns:** `Stream<List<Account>>`

## 💸 Transaction Management API

### TransactionService

Handles all financial transactions with comprehensive metadata.

#### Methods

##### `createTransaction(CreateTransactionRequest request)`

Creates a new transaction.

**Parameters:**
- `request` (CreateTransactionRequest): Transaction creation request

**Returns:** `Future<Result<Transaction>>`

**Example:**
```dart
final request = CreateTransactionRequest(
  cashbookId: 'cashbook123',
  amount: 25.50,
  currency: 'USD',
  accountId: 'account123',
  categoryId: 'food',
  description: 'Lunch at cafe',
  tags: ['lunch', 'work'],
  location: GeoLocation(latitude: 40.7128, longitude: -74.0060),
);

final result = await transactionService.createTransaction(request);
```

##### `getTransactions(String cashbookId, TransactionFilter filter)`

Retrieves transactions with filtering.

**Parameters:**
- `cashbookId` (String): Cashbook ID
- `filter` (TransactionFilter): Filter criteria

**Returns:** `Future<Result<List<Transaction>>>`

**Example:**
```dart
final filter = TransactionFilter(
  startDate: DateTime.now().subtract(Duration(days: 30)),
  endDate: DateTime.now(),
  categories: ['food', 'transport'],
  minAmount: 10.0,
  maxAmount: 100.0,
);

final result = await transactionService.getTransactions('cashbook123', filter);
```

##### `updateTransaction(String transactionId, UpdateTransactionRequest request)`

Updates an existing transaction.

**Parameters:**
- `transactionId` (String): Transaction ID
- `request` (UpdateTransactionRequest): Update request

**Returns:** `Future<Result<void>>`

##### `deleteTransaction(String transactionId)`

Deletes a transaction.

**Parameters:**
- `transactionId` (String): Transaction ID

**Returns:** `Future<Result<void>>`

##### `searchTransactions(String cashbookId, String query)`

Searches transactions by description, tags, or merchant.

**Parameters:**
- `cashbookId` (String): Cashbook ID
- `query` (String): Search query

**Returns:** `Future<Result<List<Transaction>>>`

#### Streams

##### `watchTransactions(String cashbookId, TransactionFilter filter)`

Stream of transactions with real-time updates.

**Parameters:**
- `cashbookId` (String): Cashbook ID
- `filter` (TransactionFilter): Filter criteria

**Returns:** `Stream<List<Transaction>>`

## 📊 Budget Management API

### BudgetService

Manages budgets and savings goals with intelligent tracking.

#### Methods

##### `createBudget(CreateBudgetRequest request)`

Creates a new budget.

**Parameters:**
- `request` (CreateBudgetRequest): Budget creation request

**Returns:** `Future<Result<Budget>>`

**Example:**
```dart
final request = CreateBudgetRequest(
  cashbookId: 'cashbook123',
  name: 'Monthly Food Budget',
  type: BudgetType.category,
  period: BudgetPeriod.monthly,
  amount: 500.0,
  currency: 'USD',
  categories: ['food', 'dining'],
  alertThresholds: [50, 75, 90, 100],
);

final result = await budgetService.createBudget(request);
```

##### `getCashbookBudgets(String cashbookId)`

Retrieves all budgets for a cashbook.

**Parameters:**
- `cashbookId` (String): Cashbook ID

**Returns:** `Future<Result<List<Budget>>>`

##### `getBudgetStatus(String budgetId)`

Gets current budget status and spending.

**Parameters:**
- `budgetId` (String): Budget ID

**Returns:** `Future<Result<BudgetStatus>>`

**Example:**
```dart
final status = await budgetService.getBudgetStatus('budget123');
status.when(
  success: (budgetStatus) {
    print('Spent: ${budgetStatus.spent}/${budgetStatus.budget.amount}');
    print('Remaining: ${budgetStatus.remaining}');
    print('Progress: ${budgetStatus.progressPercentage}%');
  },
  failure: (error) => print('Error: $error'),
);
```

##### `createSavingsGoal(CreateSavingsGoalRequest request)`

Creates a new savings goal.

**Parameters:**
- `request` (CreateSavingsGoalRequest): Savings goal creation request

**Returns:** `Future<Result<SavingsGoal>>`

**Example:**
```dart
final request = CreateSavingsGoalRequest(
  cashbookId: 'cashbook123',
  name: 'Emergency Fund',
  targetAmount: 10000.0,
  currency: 'USD',
  targetDate: DateTime.now().add(Duration(days: 365)),
  linkedAccountId: 'savings_account',
);

final result = await budgetService.createSavingsGoal(request);
```

##### `getCashbookGoals(String cashbookId)`

Retrieves all savings goals for a cashbook.

**Parameters:**
- `cashbookId` (String): Cashbook ID

**Returns:** `Future<Result<List<SavingsGoal>>>`

#### Streams

##### `watchCashbookBudgets(String cashbookId)`

Stream of budgets with real-time updates.

**Parameters:**
- `cashbookId` (String): Cashbook ID

**Returns:** `Stream<List<Budget>>`

## 🤖 AI Services API

### AIService

Handles natural language processing and intelligent categorization.

#### Methods

##### `processNaturalLanguage(NLPRequest request)`

Processes natural language input to extract transaction details.

**Parameters:**
- `request` (NLPRequest): Natural language processing request

**Returns:** `Future<Result<NLPResponse>>`

**Example:**
```dart
final request = NLPRequest(
  text: 'Spent $25 on coffee at Starbucks this morning',
  context: UserContext(
    defaultCurrency: 'USD',
    recentCategories: ['food', 'coffee'],
    location: 'New York',
  ),
  language: 'en',
);

final result = await aiService.processNaturalLanguage(request);
result.when(
  success: (response) {
    print('Amount: ${response.extractedTransaction.amount}');
    print('Description: ${response.extractedTransaction.description}');
    print('Suggested category: ${response.suggestedCategories.first.categoryId}');
    print('Confidence: ${response.confidence}');
  },
  failure: (error) => print('NLP failed: $error'),
);
```

##### `suggestCategories(String description, double amount, String? location)`

Suggests categories for a transaction.

**Parameters:**
- `description` (String): Transaction description
- `amount` (double): Transaction amount
- `location` (String?): Optional location

**Returns:** `Future<Result<List<CategorySuggestion>>>`

##### `learnFromCorrection(String originalText, Transaction correctedTransaction)`

Learns from user corrections to improve AI accuracy.

**Parameters:**
- `originalText` (String): Original input text
- `correctedTransaction` (Transaction): User-corrected transaction

**Returns:** `Future<Result<void>>`

##### `processVoiceInput(String audioPath)`

Converts voice input to text for transaction processing.

**Parameters:**
- `audioPath` (String): Path to audio file

**Returns:** `Future<Result<String>>`

## 📈 Analytics API

### AnalyticsService

Provides comprehensive financial analytics and insights.

#### Methods

##### `getSpendingAnalytics(String cashbookId, AnalyticsFilter filter)`

Gets spending analytics for a cashbook.

**Parameters:**
- `cashbookId` (String): Cashbook ID
- `filter` (AnalyticsFilter): Analytics filter criteria

**Returns:** `Future<Result<SpendingAnalytics>>`

**Example:**
```dart
final filter = AnalyticsFilter(
  startDate: DateTime.now().subtract(Duration(days: 90)),
  endDate: DateTime.now(),
  groupBy: GroupBy.category,
);

final result = await analyticsService.getSpendingAnalytics('cashbook123', filter);
result.when(
  success: (analytics) {
    print('Total spent: ${analytics.totalSpent}');
    print('Average per day: ${analytics.averagePerDay}');
    for (final category in analytics.categoryBreakdown) {
      print('${category.name}: ${category.amount} (${category.percentage}%)');
    }
  },
  failure: (error) => print('Analytics failed: $error'),
);
```

##### `getCashFlowAnalytics(String cashbookId, AnalyticsFilter filter)`

Gets cash flow analytics showing income vs expenses.

**Parameters:**
- `cashbookId` (String): Cashbook ID
- `filter` (AnalyticsFilter): Analytics filter criteria

**Returns:** `Future<Result<CashFlowAnalytics>>`

##### `getFinancialInsights(String cashbookId)`

Generates AI-powered financial insights and recommendations.

**Parameters:**
- `cashbookId` (String): Cashbook ID

**Returns:** `Future<Result<FinancialInsights>>`

##### `exportReport(String cashbookId, ReportConfig config)`

Exports financial report in specified format.

**Parameters:**
- `cashbookId` (String): Cashbook ID
- `config` (ReportConfig): Report configuration

**Returns:** `Future<Result<String>>` (file path)

**Example:**
```dart
final config = ReportConfig(
  format: ReportFormat.pdf,
  dateRange: DateRange.lastMonth,
  includeCharts: true,
  includeTransactionDetails: true,
);

final result = await analyticsService.exportReport('cashbook123', config);
```

## 👥 Group Finance API

### GroupService

Manages shared expenses and group finance features.

#### Methods

##### `createGroup(String name, List<String> memberEmails)`

Creates a new expense sharing group.

**Parameters:**
- `name` (String): Group name
- `memberEmails` (List<String>): List of member email addresses

**Returns:** `Future<Result<Group>>`

##### `addGroupExpense(String groupId, CreateGroupExpenseRequest request)`

Adds a new group expense.

**Parameters:**
- `groupId` (String): Group ID
- `request` (CreateGroupExpenseRequest): Expense creation request

**Returns:** `Future<Result<GroupExpense>>`

**Example:**
```dart
final request = CreateGroupExpenseRequest(
  amount: 120.0,
  description: 'Dinner at restaurant',
  paidBy: 'user123',
  splits: [
    ExpenseSplit(userId: 'user123', amount: 40.0),
    ExpenseSplit(userId: 'user456', amount: 40.0),
    ExpenseSplit(userId: 'user789', amount: 40.0),
  ],
);

final result = await groupService.addGroupExpense('group123', request);
```

##### `settleExpense(String expenseId, SettlementType settlementType)`

Settles a group expense.

**Parameters:**
- `expenseId` (String): Expense ID
- `settlementType` (SettlementType): How to settle (collect, settle, convert_to_loan)

**Returns:** `Future<Result<void>>`

##### `getGroupBalances(String groupId)`

Gets current balances for all group members.

**Parameters:**
- `groupId` (String): Group ID

**Returns:** `Future<Result<List<GroupBalance>>>`

##### `getUserGroups(String userId)`

Gets all groups for a user.

**Parameters:**
- `userId` (String): User ID

**Returns:** `Future<Result<List<Group>>>`

#### Streams

##### `watchGroup(String groupId)`

Stream of group updates.

**Parameters:**
- `groupId` (String): Group ID

**Returns:** `Stream<Group>`

## 💳 Loan Management API

### LoanService

Manages personal lending and borrowing.

#### Methods

##### `createLoan(CreateLoanRequest request)`

Creates a new loan record.

**Parameters:**
- `request` (CreateLoanRequest): Loan creation request

**Returns:** `Future<Result<Loan>>`

**Example:**
```dart
final request = CreateLoanRequest(
  cashbookId: 'cashbook123',
  type: LoanType.lent,
  counterpartyName: 'John Doe',
  principalAmount: 1000.0,
  currency: 'USD',
  interestRate: 5.0,
  interestType: InterestType.simple,
  dueDate: DateTime.now().add(Duration(days: 90)),
);

final result = await loanService.createLoan(request);
```

##### `addPayment(String loanId, LoanPayment payment)`

Adds a payment to a loan.

**Parameters:**
- `loanId` (String): Loan ID
- `payment` (LoanPayment): Payment details

**Returns:** `Future<Result<void>>`

##### `settleLoan(String loanId, SettlementType settlementType)`

Settles a loan with specified method.

**Parameters:**
- `loanId` (String): Loan ID
- `settlementType` (SettlementType): Settlement method

**Returns:** `Future<Result<void>>`

##### `getCashbookLoans(String cashbookId)`

Gets all loans for a cashbook.

**Parameters:**
- `cashbookId` (String): Cashbook ID

**Returns:** `Future<Result<List<Loan>>>`

##### `getOverdueLoans(String cashbookId)`

Gets overdue loans for a cashbook.

**Parameters:**
- `cashbookId` (String): Cashbook ID

**Returns:** `Future<Result<List<Loan>>>`

## 📋 Data Models

### Core Models

#### User
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
}
```

#### Transaction
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
}
```

#### Account
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
}
```

### Request Models

#### CreateTransactionRequest
```dart
@freezed
class CreateTransactionRequest with _$CreateTransactionRequest {
  const factory CreateTransactionRequest({
    required String cashbookId,
    required double amount,
    required String currency,
    required String accountId,
    required String categoryId,
    required String description,
    @Default([]) List<String> tags,
    GeoLocation? location,
    @Default([]) List<Attachment> attachments,
    List<TransactionSplit>? splits,
    @Default(false) bool useAI,
  }) = _CreateTransactionRequest;
}
```

### Response Models

#### Result<T>
```dart
sealed class Result<T> {
  const Result();
  
  R when<R>({
    required R Function(T data) success,
    required R Function(Exception error) failure,
  });
}

class Success<T> extends Result<T> {
  const Success(this.data);
  final T data;
}

class Failure<T> extends Result<T> {
  const Failure(this.error);
  final Exception error;
}
```

## ⚠️ Error Handling

### Exception Types

#### AppException
Base exception class for all application errors.

```dart
abstract class AppException implements Exception {
  const AppException(this.message, [this.code]);
  
  final String message;
  final String? code;
}
```

#### AuthenticationException
```dart
class AuthenticationException extends AppException {
  const AuthenticationException(String message, [String? code])
      : super(message, code);
}
```

#### ValidationException
```dart
class ValidationException extends AppException {
  const ValidationException(String message, [this.field])
      : super(message, 'validation_error');
  
  final String? field;
}
```

#### NetworkException
```dart
class NetworkException extends AppException {
  const NetworkException(String message, [this.statusCode])
      : super(message, 'network_error');
  
  final int? statusCode;
}
```

### Error Handling Patterns

#### Service Layer
```dart
Future<Result<Transaction>> createTransaction(CreateTransactionRequest request) async {
  try {
    // Validate request
    final validation = _validateRequest(request);
    if (validation != null) {
      return Failure(ValidationException(validation));
    }
    
    // Create transaction
    final transaction = await _repository.create(request);
    return Success(transaction);
  } on FirebaseException catch (e) {
    return Failure(NetworkException('Firebase error: ${e.message}', e.code));
  } on ValidationException catch (e) {
    return Failure(e);
  } catch (e) {
    return Failure(AppException('Unexpected error: $e'));
  }
}
```

#### UI Layer
```dart
class TransactionFormPage extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(transactionFormProvider, (previous, next) {
      next.whenOrNull(
        error: (error, stackTrace) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_getErrorMessage(error)),
              backgroundColor: Colors.red,
            ),
          );
        },
      );
    });
    
    // ... rest of widget
  }
  
  String _getErrorMessage(Object error) {
    if (error is ValidationException) {
      return 'Validation error: ${error.message}';
    } else if (error is NetworkException) {
      return 'Network error: ${error.message}';
    } else if (error is AuthenticationException) {
      return 'Authentication error: ${error.message}';
    } else {
      return 'An unexpected error occurred';
    }
  }
}
```

## 🛠️ Development Tools Integration

### GitMCP Server Integration

The GitMCP server provides AI-assisted Git operations and repository analysis through the Model Context Protocol.

#### Current Configuration

The project has GitMCP and Sequential Thinking MCP configured at the user level (`~/.kiro/settings/mcp.json`):

```json
{
  "mcpServers": {
    "gitmcp": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://gitmcp.io/{owner}/{repo}"
      ]
    },
    "sequential-thinking": {
      "command": "npx",
      "args": [
        "-y",
        "@modelcontextprotocol/server-sequential-thinking"
      ]
    }
  }
}
```

#### Features

- **Repository Analysis**: AI-powered insights into codebase structure and patterns
- **Git Operations**: Intelligent assistance with Git workflows and operations
- **Code Context**: Enhanced understanding of repository history and changes
- **Cross-Project Availability**: User-level configuration enables use across multiple projects
- **Sequential Thinking**: Advanced reasoning capabilities for complex problem-solving
- **Multi-Step Analysis**: Structured thinking processes for development decisions

#### Usage

The MCP servers integrate with Kiro AI assistant to provide:

1. **Repository Insights**: Analysis of code structure, dependencies, and patterns
2. **Git Workflow Assistance**: Help with branching, merging, and conflict resolution
3. **Code Review Support**: AI-assisted code review and suggestions
4. **Documentation Generation**: Automated documentation updates based on code changes
5. **Problem Solving**: Sequential thinking for complex development challenges
6. **Decision Support**: Multi-step analysis for architectural and design decisions

### Flutter Inspector MCP Server

The Flutter Inspector MCP (Model Context Protocol) server provides enhanced debugging capabilities through AI-assisted development workflows.

#### Configuration

The MCP server can be configured in `.kiro/settings/mcp.json`. The project currently has GitMCP configured at the user level for repository integration:

**User-level configuration** (`~/.kiro/settings/mcp.json`):
```json
{
  "mcpServers": {
    "gitmcp": {
      "command": "npx",
      "args": [
        "mcp-remote",
        "https://gitmcp.io/{owner}/{repo}"
      ]
    }
  }
}
```

**Additional MCP servers can be added** (e.g., Flutter Inspector):
```json
{
  "mcpServers": {
    "flutter-docs": {
      "command": "npx",
      "args": ["flutter-mcp", "--stdio"],
      "disabled": false
    }
  }
}
```

#### Features

- **Widget Tree Inspection**: Real-time analysis of Flutter widget hierarchy
- **Performance Analysis**: Memory usage and rendering performance insights
- **Resource Inspection**: Image and asset analysis during development
- **AI-Assisted Debugging**: Intelligent suggestions for common Flutter issues
- **Live Application Debugging**: Connects to Dart VM on localhost:8181

#### Usage

When configured, the MCP server integrates with Kiro AI assistant to provide:

1. **Widget Analysis**: Inspect widget properties and state
2. **Performance Insights**: Identify performance bottlenecks
3. **Code Suggestions**: AI-powered recommendations for Flutter best practices
4. **Debugging Assistance**: Contextual help for Flutter-specific issues

#### Troubleshooting

**MCP Server Connection Issues:**
```bash
# Verify Node.js and npx are installed
node --version
npx --version

# Test Flutter MCP server manually
npx flutter-mcp --stdio

# Check Dart VM is running (for live debugging)
flutter run --debug
# Dart VM should be accessible on localhost:8181
```

**Common Issues:**
- Ensure Flutter application is running in debug mode for live inspection
- Verify network connectivity to localhost:8181
- Check that `flutter-mcp` package is accessible via npx
- Restart Kiro if MCP server fails to connect after configuration changes

## 🔧 Configuration

### Environment Configuration

Services can be configured using environment-specific settings:

```dart
class ApiConfig {
  static const String baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'https://api.cashense.com',
  );
  
  static const bool enableAnalytics = bool.fromEnvironment(
    'ENABLE_ANALYTICS',
    defaultValue: true,
  );
  
  static const int requestTimeoutSeconds = int.fromEnvironment(
    'REQUEST_TIMEOUT',
    defaultValue: 30,
  );
}
```

### Service Initialization

```dart
Future<void> initializeServices() async {
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize local storage
  await Hive.initFlutter();
  
  // Register service providers
  final container = ProviderContainer();
  
  // Initialize core services
  await container.read(storageServiceProvider).initialize();
  await container.read(authServiceProvider).initialize();
  await container.read(aiServiceProvider).initialize();
}
```

This API documentation provides comprehensive coverage of all Cashense services and their interfaces. Each service follows consistent patterns for error handling, data validation, and response formatting.