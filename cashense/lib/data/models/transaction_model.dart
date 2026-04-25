import 'package:cloud_firestore/cloud_firestore.dart';

enum TransactionType { expense, income, transfer }

enum RecurringInterval { weekly, monthly, yearly }

class TransactionModel {
  final String id;
  final TransactionType type;
  final double amount;
  final String category;
  final String accountId;
  final String? toAccountId;
  final DateTime date;
  final String? note;
  final List<String> tags;
  final String? receiptUrl;
  final bool isRecurring;
  final RecurringInterval? recurringInterval;
  final String? groupExpenseId;
  final String? workspaceId;
  final DateTime createdAt;

  const TransactionModel({
    required this.id,
    required this.type,
    required this.amount,
    required this.category,
    required this.accountId,
    this.toAccountId,
    required this.date,
    this.note,
    this.tags = const [],
    this.receiptUrl,
    this.isRecurring = false,
    this.recurringInterval,
    this.groupExpenseId,
    this.workspaceId,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'type': type.name,
    'amount': amount,
    'category': category,
    'accountId': accountId,
    'toAccountId': toAccountId,
    'date': Timestamp.fromDate(date),
    'note': note,
    'tags': tags,
    'receiptUrl': receiptUrl,
    'isRecurring': isRecurring,
    'recurringInterval': recurringInterval?.name,
    'groupExpenseId': groupExpenseId,
    'workspaceId': workspaceId,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory TransactionModel.fromJson(Map<String, dynamic> json) {
    return TransactionModel(
      id: json['id'] as String,
      type: TransactionType.values.byName(json['type'] as String),
      amount: (json['amount'] as num).toDouble(),
      category: json['category'] as String,
      accountId: json['accountId'] as String,
      toAccountId: json['toAccountId'] as String?,
      date: _toDate(json['date'])!,
      note: json['note'] as String?,
      tags: (json['tags'] as List?)?.cast<String>() ?? const [],
      receiptUrl: json['receiptUrl'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurringInterval: json['recurringInterval'] == null
          ? null
          : RecurringInterval.values.byName(json['recurringInterval'] as String),
      groupExpenseId: json['groupExpenseId'] as String?,
      workspaceId: json['workspaceId'] as String?,
      createdAt: _toDate(json['createdAt'])!,
    );
  }

  factory TransactionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TransactionModel.fromJson({...data, 'id': doc.id});
  }

  TransactionModel copyWith({
    String? id,
    TransactionType? type,
    double? amount,
    String? category,
    String? accountId,
    String? toAccountId,
    DateTime? date,
    String? note,
    List<String>? tags,
    String? receiptUrl,
    bool? isRecurring,
    RecurringInterval? recurringInterval,
    String? groupExpenseId,
    String? workspaceId,
    DateTime? createdAt,
  }) {
    return TransactionModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amount: amount ?? this.amount,
      category: category ?? this.category,
      accountId: accountId ?? this.accountId,
      toAccountId: toAccountId ?? this.toAccountId,
      date: date ?? this.date,
      note: note ?? this.note,
      tags: tags ?? this.tags,
      receiptUrl: receiptUrl ?? this.receiptUrl,
      isRecurring: isRecurring ?? this.isRecurring,
      recurringInterval: recurringInterval ?? this.recurringInterval,
      groupExpenseId: groupExpenseId ?? this.groupExpenseId,
      workspaceId: workspaceId ?? this.workspaceId,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}

DateTime? _toDate(dynamic v) {
  if (v == null) return null;
  if (v is Timestamp) return v.toDate();
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  return null;
}
