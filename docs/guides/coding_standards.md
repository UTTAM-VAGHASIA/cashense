# Coding Standards

This document establishes the coding standards and guidelines for the Cashense application. Following these standards ensures consistency, maintainability, and collaboration efficiency.

## Table of Contents
- [Code Formatting](#code-formatting)
- [Naming Conventions](#naming-conventions)
- [Code Organization](#code-organization)
- [Riverpod Usage](#riverpod-usage)
- [Documentation](#documentation)
- [Testing](#testing)
- [Error Handling](#error-handling)
- [Performance Considerations](#performance-considerations)

## Code Formatting

### Dart Format
- Use the official Dart formatter with a line length of 80 characters:
  ```bash
  dart format --line-length=80 lib/
  ```
- Configure your IDE to format on save

### Linting
- Follow all rules defined in `analysis_options.yaml`
- Use `dart_code_metrics` for additional static analysis
- Aim for zero linting warnings in production code

## Naming Conventions

### Files and Directories
- Use `snake_case` for file and directory names:
  - `transaction_list_page.dart`
  - `account_repository.dart`
  - `transaction_model.dart`
- Feature files should be organized by type:
  - `features/transactions/models/`
  - `features/transactions/pages/`
  - `features/transactions/widgets/`

### Classes
- Use `PascalCase` for class names:
  - `TransactionModel`
  - `AccountRepository`
  - `BudgetListPage`
- Prefix interfaces with "I" when distinction is important:
  - `ITransactionRepository`
- Prefix abstract classes when appropriate:
  - `BaseRepository`

### Variables and Functions
- Use `camelCase` for variables, functions, and methods:
  - `transactionList`
  - `fetchTransactions()`
  - `calculateBalance()`
- Use meaningful, descriptive names
- Boolean variables should have "is", "has", or "should" prefixes:
  - `isLoading`
  - `hasTransactions`
  - `shouldRefresh`

### Constants
- Use `SCREAMING_SNAKE_CASE` for top-level constants:
  - `const MAX_TRANSACTION_LIMIT = 100;`
- Use `kConstantName` for constant instance variables:
  - `final kDefaultRadius = 8.0;`

### Enums
- Use `PascalCase` for enum types and values:
  ```dart
  enum TransactionType {
    Income,
    Expense,
    Transfer,
  }
  ```

## Code Organization

### Project Structure
Follow the project structure defined in `project_structure.md`.

### Feature Structure
Each feature should be organized with the following structure:
```
features/
  accounts/
    models/           # Data models 
    repositories/     # Data access
    providers/        # State management
    pages/            # Screens
    widgets/          # UI components
    utils/            # Helper functions
```

### File Structure
- One class per file (except for small related classes)
- Order file content as follows:
  1. Imports (Dart, then packages, then project)
  2. Constants
  3. Class definition
  4. Static variables
  5. Instance variables
  6. Constructors
  7. Factory methods
  8. Getters/setters
  9. Public methods
  10. Private methods
  11. Override methods

### Import Ordering
Order imports as follows:
```dart
// Dart imports
import 'dart:async';
import 'dart:io';

// Package imports (alphabetical)
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Project imports (by relative path depth)
import '../../core/utils/formatters.dart';
import '../models/transaction.dart';
```

## Riverpod Usage

### Provider Naming
- For state providers: `{feature}StateProvider`
- For notifier providers: `{feature}NotifierProvider`
- For repository providers: `{feature}RepositoryProvider`

### Provider Organization
- Group related providers in a single file:
  - `features/transactions/providers/transaction_providers.dart`
- Define providers as global variables:
  ```dart
  final transactionsProvider = StateNotifierProvider<TransactionsNotifier, TransactionsState>((ref) {
    final repository = ref.watch(transactionRepositoryProvider);
    return TransactionsNotifier(repository);
  });
  ```

### State Management
- Use `freezed` for immutable state classes:
  ```dart
  @freezed
  class TransactionsState with _$TransactionsState {
    const factory TransactionsState({
      @Default([]) List<Transaction> transactions,
      @Default(false) bool isLoading,
      Object? error,
    }) = _TransactionsState;
  }
  ```
- Use `StateNotifier` for complex state:
  ```dart
  class TransactionsNotifier extends StateNotifier<TransactionsState> {
    TransactionsNotifier(this._repository) : super(TransactionsState());
    
    final TransactionRepository _repository;
    
    Future<void> fetchTransactions() async {
      state = state.copyWith(isLoading: true, error: null);
      try {
        final transactions = await _repository.getTransactions();
        state = state.copyWith(transactions: transactions, isLoading: false);
      } catch (e) {
        state = state.copyWith(error: e, isLoading: false);
      }
    }
  }
  ```

## Documentation

### Code Comments
- Use /// for documentation comments:
  ```dart
  /// Calculates the account balance based on all transactions.
  /// 
  /// Returns a [double] representing the current balance.
  double calculateBalance() {
    // Implementation
  }
  ```
- Comment complex logic and business rules:
  ```dart
  // Apply reconciliation logic: mark all transactions before
  // the reconciliation date as reconciled
  transactions.where((t) => t.date.isBefore(reconciliationDate))
      .forEach((t) => t.isReconciled = true);
  ```
- Include parameter and return type documentation for public methods

### File Headers
Add a file header to each file:
```dart
/// Account repository implementation.
///
/// This file contains the implementation of the account repository
/// which handles data access for accounts and sub-accounts.
///
/// Created by: John Smith
/// Last modified: 2023-10-15
```

### TODOs
- Format TODOs with name and date:
  ```dart
  // TODO(username): Implement caching mechanism (2023-10-15)
  ```

## Testing

### Test File Naming
- Name test files with `_test.dart` suffix:
  - `transaction_model_test.dart`
  - `account_repository_test.dart`

### Test Organization
- Organize tests with `group` and `test`:
  ```dart
  group('TransactionModel', () {
    test('fromJson creates correct instance', () {
      // Test implementation
    });
    
    test('toJson outputs correct format', () {
      // Test implementation
    });
  });
  ```

### Mock Dependencies
- Use `mockito` or `mocktail` for mocking dependencies
- Create mock classes in a separate file:
  - `mocks/mock_transaction_repository.dart`

### Riverpod Testing
- Use `riverpod_test` for testing providers:
  ```dart
  test('transactionsProvider loads transactions correctly', () async {
    final container = ProviderContainer(
      overrides: [
        transactionRepositoryProvider.overrideWithValue(mockRepository),
      ],
    );
    
    // Test implementation
  });
  ```

## Error Handling

### Exceptions
- Create custom exceptions for specific error cases:
  ```dart
  class TransactionNotFoundException implements Exception {
    final String message;
    TransactionNotFoundException(this.message);
  }
  ```

### Error Propagation
- Use structured error handling with try/catch:
  ```dart
  try {
    final result = await repository.fetchTransactions();
    return right(result);
  } on NetworkException catch (e) {
    return left(NetworkFailure(e.message));
  } on ServerException catch (e) {
    return left(ServerFailure(e.message));
  } catch (e) {
    return left(UnexpectedFailure(e.toString()));
  }
  ```

### User-Facing Errors
- Don't expose raw error details to users
- Map technical errors to user-friendly messages:
  ```dart
  String getUserErrorMessage(Failure failure) {
    return switch (failure) {
      NetworkFailure() => 'Please check your internet connection',
      ServerFailure() => 'Something went wrong on our end',
      _ => 'An unexpected error occurred',
    };
  }
  ```

## Performance Considerations

### State Management
- Minimize widget rebuilds:
  - Use `select` to watch specific parts of state:
    ```dart
    final isLoading = ref.watch(transactionsProvider.select((s) => s.isLoading));
    ```
  - Use `Consumer` or `ConsumerWidget` to limit rebuild scope

### Lists
- Use `const` constructors when possible
- Implement pagination for long lists
- Use `ListView.builder` instead of `ListView` for dynamic lists
- Use `O(1)` operations when working with large collections

### Images
- Use `cached_network_image` for network images
- Compress and resize images before upload
- Lazy load images that are not visible

### Database
- Minimize database operations
- Use batch operations when possible
- Implement caching for frequently accessed data
- Create appropriate indexes as defined in the schema document 