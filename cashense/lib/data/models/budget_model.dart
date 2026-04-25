import 'package:cloud_firestore/cloud_firestore.dart';

enum BudgetPeriod { weekly, monthly, yearly }

class BudgetModel {
  final String id;
  final String category;
  final double amount;
  final BudgetPeriod period;
  final int month;
  final int year;
  final double spent;
  final bool alertAt80;
  final bool alertAt100;
  final bool carryForward;
  final DateTime createdAt;

  const BudgetModel({
    required this.id,
    required this.category,
    required this.amount,
    this.period = BudgetPeriod.monthly,
    required this.month,
    required this.year,
    this.spent = 0,
    this.alertAt80 = true,
    this.alertAt100 = true,
    this.carryForward = false,
    required this.createdAt,
  });

  double get percentUsed => amount == 0 ? 0 : (spent / amount) * 100;
  double get remaining => amount - spent;
  bool get isOverBudget => spent > amount;

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'amount': amount,
    'period': period.name,
    'month': month,
    'year': year,
    'spent': spent,
    'alertAt80': alertAt80,
    'alertAt100': alertAt100,
    'carryForward': carryForward,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory BudgetModel.fromJson(Map<String, dynamic> json) => BudgetModel(
    id: json['id'] as String,
    category: json['category'] as String,
    amount: (json['amount'] as num).toDouble(),
    period: BudgetPeriod.values.byName(
      json['period'] as String? ?? 'monthly',
    ),
    month: json['month'] as int,
    year: json['year'] as int,
    spent: (json['spent'] as num?)?.toDouble() ?? 0,
    alertAt80: json['alertAt80'] as bool? ?? true,
    alertAt100: json['alertAt100'] as bool? ?? true,
    carryForward: json['carryForward'] as bool? ?? false,
    createdAt: _toDate(json['createdAt'])!,
  );

  factory BudgetModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BudgetModel.fromJson({...data, 'id': doc.id});
  }

  BudgetModel copyWith({
    String? id,
    String? category,
    double? amount,
    BudgetPeriod? period,
    int? month,
    int? year,
    double? spent,
    bool? alertAt80,
    bool? alertAt100,
    bool? carryForward,
    DateTime? createdAt,
  }) => BudgetModel(
    id: id ?? this.id,
    category: category ?? this.category,
    amount: amount ?? this.amount,
    period: period ?? this.period,
    month: month ?? this.month,
    year: year ?? this.year,
    spent: spent ?? this.spent,
    alertAt80: alertAt80 ?? this.alertAt80,
    alertAt100: alertAt100 ?? this.alertAt100,
    carryForward: carryForward ?? this.carryForward,
    createdAt: createdAt ?? this.createdAt,
  );
}

DateTime? _toDate(dynamic v) {
  if (v == null) return null;
  if (v is Timestamp) return v.toDate();
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  return null;
}
