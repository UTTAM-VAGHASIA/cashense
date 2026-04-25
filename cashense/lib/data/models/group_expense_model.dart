import 'package:cloud_firestore/cloud_firestore.dart';

enum SplitType { equal, percentage, exact, shares }

class GroupExpenseModel {
  final String id;
  final String description;
  final double amount;
  final String paidBy;
  final SplitType splitType;
  final Map<String, double> splits;
  final DateTime date;
  final String? category;
  final DateTime createdAt;

  const GroupExpenseModel({
    required this.id,
    required this.description,
    required this.amount,
    required this.paidBy,
    this.splitType = SplitType.equal,
    this.splits = const {},
    required this.date,
    this.category,
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'description': description,
    'amount': amount,
    'paidBy': paidBy,
    'splitType': splitType.name,
    'splits': splits,
    'date': Timestamp.fromDate(date),
    'category': category,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory GroupExpenseModel.fromJson(Map<String, dynamic> json) =>
      GroupExpenseModel(
        id: json['id'] as String,
        description: json['description'] as String,
        amount: (json['amount'] as num).toDouble(),
        paidBy: json['paidBy'] as String,
        splitType: SplitType.values.byName(
          json['splitType'] as String? ?? 'equal',
        ),
        splits:
            (json['splits'] as Map?)?.map(
              (k, v) => MapEntry(k as String, (v as num).toDouble()),
            ) ??
            const {},
        date: _toDate(json['date'])!,
        category: json['category'] as String?,
        createdAt: _toDate(json['createdAt'])!,
      );

  factory GroupExpenseModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupExpenseModel.fromJson({...data, 'id': doc.id});
  }

  GroupExpenseModel copyWith({
    String? id,
    String? description,
    double? amount,
    String? paidBy,
    SplitType? splitType,
    Map<String, double>? splits,
    DateTime? date,
    String? category,
    DateTime? createdAt,
  }) => GroupExpenseModel(
    id: id ?? this.id,
    description: description ?? this.description,
    amount: amount ?? this.amount,
    paidBy: paidBy ?? this.paidBy,
    splitType: splitType ?? this.splitType,
    splits: splits ?? this.splits,
    date: date ?? this.date,
    category: category ?? this.category,
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
