import 'package:cloud_firestore/cloud_firestore.dart';

class SavingGoalModel {
  final String id;
  final String name;
  final double targetAmount;
  final double currentAmount;
  final DateTime deadline;
  final String? linkedAccountId;
  final String? icon;
  final String? color;
  final DateTime createdAt;

  const SavingGoalModel({
    required this.id,
    required this.name,
    required this.targetAmount,
    this.currentAmount = 0,
    required this.deadline,
    this.linkedAccountId,
    this.icon,
    this.color,
    required this.createdAt,
  });

  double get progress =>
      targetAmount == 0 ? 0 : (currentAmount / targetAmount).clamp(0, 1);
  double get remaining => targetAmount - currentAmount;
  bool get isAchieved => currentAmount >= targetAmount;

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'targetAmount': targetAmount,
    'currentAmount': currentAmount,
    'deadline': Timestamp.fromDate(deadline),
    'linkedAccountId': linkedAccountId,
    'icon': icon,
    'color': color,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory SavingGoalModel.fromJson(Map<String, dynamic> json) =>
      SavingGoalModel(
        id: json['id'] as String,
        name: json['name'] as String,
        targetAmount: (json['targetAmount'] as num).toDouble(),
        currentAmount: (json['currentAmount'] as num?)?.toDouble() ?? 0,
        deadline: _toDate(json['deadline'])!,
        linkedAccountId: json['linkedAccountId'] as String?,
        icon: json['icon'] as String?,
        color: json['color'] as String?,
        createdAt: _toDate(json['createdAt'])!,
      );

  factory SavingGoalModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SavingGoalModel.fromJson({...data, 'id': doc.id});
  }

  SavingGoalModel copyWith({
    String? id,
    String? name,
    double? targetAmount,
    double? currentAmount,
    DateTime? deadline,
    String? linkedAccountId,
    String? icon,
    String? color,
    DateTime? createdAt,
  }) => SavingGoalModel(
    id: id ?? this.id,
    name: name ?? this.name,
    targetAmount: targetAmount ?? this.targetAmount,
    currentAmount: currentAmount ?? this.currentAmount,
    deadline: deadline ?? this.deadline,
    linkedAccountId: linkedAccountId ?? this.linkedAccountId,
    icon: icon ?? this.icon,
    color: color ?? this.color,
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
