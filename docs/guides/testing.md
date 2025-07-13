# Testing Strategy

This document outlines the testing strategy for the Cashense application. It establishes guidelines for ensuring code quality, functionality, and reliability throughout the development process.

## Testing Philosophy

The testing approach for Cashense follows these key principles:

1. **Shift Left**: Test early and often to catch issues before they propagate
2. **Pyramid Structure**: More unit tests than integration tests, more integration tests than end-to-end tests
3. **Test Business Logic**: Focus testing on core financial calculations and business rules
4. **Automate**: Prioritize automated testing with manual testing as a supplement
5. **Regression Prevention**: Prevent regressions through comprehensive test coverage

## Test Types

### Unit Tests

Unit tests verify individual components in isolation.

#### Coverage Targets:
- **Models**: 100% coverage
- **Repositories**: 90% coverage
- **Providers/Notifiers**: 90% coverage
- **Utils**: 95% coverage

#### What to Test:
- Model serialization/deserialization
- Data transformation logic
- Mathematical calculations (budgets, balances)
- Business rules and validation
- Repository methods with mocked data sources
- Provider state transitions

#### Example:
```dart
group('TransactionModel', () {
  test('fromJson should correctly parse transaction data', () {
    final json = {
      'id': '123',
      'amount': 1000,
      'category_id': 'cat1',
      'date': '2023-10-15',
      'type': 'expense'
    };
    
    final transaction = TransactionModel.fromJson(json);
    
    expect(transaction.id, '123');
    expect(transaction.amount, 1000);
    expect(transaction.categoryId, 'cat1');
    expect(transaction.date, DateTime(2023, 10, 15));
    expect(transaction.type, TransactionType.Expense);
  });
});
```

### Widget Tests

Widget tests verify that UI components render correctly and handle user interactions properly.

#### Coverage Targets:
- **Pages**: 70% coverage
- **Reusable Widgets**: 85% coverage
- **Forms**: 80% coverage

#### What to Test:
- Widget rendering and layout
- User interactions (tapping, scrolling, form input)
- State-dependent UI changes
- Error states and loading indicators
- Form validation and submission

#### Example:
```dart
testWidgets('TransactionFormWidget validates amount field', (WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      child: MaterialApp(
        home: TransactionFormWidget(),
      ),
    ),
  );
  
  // Submit without entering amount
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  
  // Verify error message appears
  expect(find.text('Amount is required'), findsOneWidget);
  
  // Enter valid amount
  await tester.enterText(find.byKey(Key('amountField')), '100');
  await tester.tap(find.byType(ElevatedButton));
  await tester.pump();
  
  // Verify error is gone
  expect(find.text('Amount is required'), findsNothing);
});
```

### Integration Tests

Integration tests verify that multiple components work together correctly.

#### Coverage Targets:
- **Core Workflows**: 80% coverage
- **Critical Paths**: 90% coverage

#### What to Test:
- End-to-end workflows (adding transaction, creating budget)
- Navigation between screens
- Data persistence and retrieval
- Component interaction
- Backend integration

#### Example:
```dart
testWidgets('Adding transaction updates account balance', (WidgetTester tester) async {
  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        // Override repository with test implementation
        accountRepositoryProvider.overrideWithValue(mockAccountRepository),
        transactionRepositoryProvider.overrideWithValue(mockTransactionRepository),
      ],
      child: MaterialApp(
        home: AccountDetailsScreen(accountId: 'account1'),
      ),
    ),
  );
  
  // Verify initial balance
  expect(find.text('₹1,000.00'), findsOneWidget);
  
  // Add new transaction
  await tester.tap(find.byIcon(Icons.add));
  await tester.pumpAndSettle();
  
  await tester.enterText(find.byKey(Key('amountField')), '500');
  await tester.enterText(find.byKey(Key('descriptionField')), 'Test transaction');
  await tester.tap(find.text('Save'));
  await tester.pumpAndSettle();
  
  // Verify balance updated
  expect(find.text('₹500.00'), findsOneWidget);
});
```

### Golden Tests

Golden tests verify that UI components match expected visual appearance.

#### Coverage Targets:
- **Core UI Components**: 60% coverage
- **Theme Variations**: Test light and dark themes

#### What to Test:
- Component appearance in different states
- Responsiveness to different screen sizes
- Theme consistency

#### Example:
```dart
testWidgets('TransactionCard matches golden file', (WidgetTester tester) async {
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.lightTheme,
      home: Scaffold(
        body: TransactionCard(
          transaction: sampleTransaction,
        ),
      ),
    ),
  );
  
  await expectLater(
    find.byType(TransactionCard),
    matchesGoldenFile('goldens/transaction_card.png'),
  );
});
```

## Test Environment

### Test Doubles

For effective isolation testing, use the following test doubles:

1. **Mocks**: Use for complex dependencies with behavior verification
   - Example: `MockTransactionRepository`

2. **Fakes**: Use for simpler dependencies where behavior implementation is needed
   - Example: `FakeAuthService`

3. **Stubs**: Use for providing predefined responses
   - Example: `StubSupabaseClient`

### Supabase Testing

For testing Supabase integration:

1. Create a test Supabase project for integration tests
2. Use the `supabase_flutter_test` package for local development
3. Mock Supabase responses for unit tests:

```dart
class MockSupabaseClient extends Mock implements SupabaseClient {
  @override
  PostgrestQueryBuilder<Map<String, dynamic>> from(String table) {
    return MockQueryBuilder();
  }
}
```

### Riverpod Testing

For testing Riverpod providers:

1. Use `ProviderContainer` with overrides for unit testing
2. Use `ProviderScope` with overrides for widget testing
3. Listen to provider state changes with `addListener`:

```dart
test('transactionsProvider should update state when fetching transactions', () {
  final container = ProviderContainer(
    overrides: [
      transactionRepositoryProvider.overrideWithValue(mockRepository),
    ],
  );
  
  final states = <TransactionsState>[];
  container.listen<TransactionsState>(
    transactionsProvider,
    (_, state) => states.add(state),
    fireImmediately: true,
  );
  
  // Trigger the notifier method
  container.read(transactionsProvider.notifier).fetchTransactions();
  
  expect(states[0].isLoading, false);
  expect(states[1].isLoading, true);
  expect(states[2].isLoading, false);
  expect(states[2].transactions, isNotEmpty);
});
```

## Continuous Integration

### Pipeline Setup

The CI pipeline will run tests at different stages:

1. **PR Builds**:
   - Run all unit tests
   - Run widget tests
   - Verify code coverage thresholds
   - Run static analysis

2. **Nightly Builds**:
   - Run all unit tests
   - Run all widget tests
   - Run integration tests
   - Generate coverage reports

### Coverage Reports

Use `lcov` to generate coverage reports:

```bash
flutter test --coverage
genhtml coverage/lcov.info -o coverage/html
```

## Manual Testing

Despite automated testing, certain aspects require manual verification:

1. **UX Testing**: Flow and usability testing
2. **Visual Inspection**: Design consistency across devices
3. **Performance Testing**: Subjective performance on real devices
4. **Accessibility**: Screen reader compatibility

## Test Data

### Test Fixtures

Create fixture files for test data:

```dart
// fixtures/transactions.dart
final sampleTransactions = [
  TransactionModel(
    id: '1',
    amount: 1000,
    categoryId: 'cat1',
    date: DateTime(2023, 10, 15),
    type: TransactionType.Expense,
    description: 'Groceries',
  ),
  // More sample transactions
];
```

### Data Generators

Use generators for creating varied test data:

```dart
// Generate a random transaction
TransactionModel generateTransaction({
  String? categoryId,
  TransactionType? type,
}) {
  return TransactionModel(
    id: generateUuid(),
    amount: Random().nextInt(10000),
    categoryId: categoryId ?? 'cat${Random().nextInt(5) + 1}',
    date: DateTime.now().subtract(Duration(days: Random().nextInt(30))),
    type: type ?? (Random().nextBool() ? TransactionType.Income : TransactionType.Expense),
    description: 'Test Transaction ${Random().nextInt(100)}',
  );
}
```

## Testing Schedule

### Development Phase

During active development:
- Write unit tests alongside new code
- Write widget tests for new UI components
- Run local tests before committing

### Sprint Schedule

For each sprint:
- Integration tests for completed features by sprint end
- Bug fixes require regression tests
- UI review includes golden test updates

## Resources

### Recommended Reading

- [Testing Flutter Apps](https://docs.flutter.dev/testing)
- [Effective Dart: Testing](https://dart.dev/guides/testing)
- [Riverpod Testing Documentation](https://riverpod.dev/docs/cookbooks/testing)

### Tools

- [mocktail](https://pub.dev/packages/mocktail)
- [bloc_test](https://pub.dev/packages/bloc_test)
- [golden_toolkit](https://pub.dev/packages/golden_toolkit)
- [test_coverage](https://pub.dev/packages/test_coverage) 