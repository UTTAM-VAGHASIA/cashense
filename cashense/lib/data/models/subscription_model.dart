import 'package:cloud_firestore/cloud_firestore.dart';

enum BillingCycle { weekly, monthly, quarterly, yearly }

class SubscriptionModel {
  final String id;
  final String name;
  final String? merchant;
  final double amount;
  final BillingCycle billingCycle;
  final DateTime nextBillingDate;
  final DateTime? lastChargedDate;
  final String? accountId;
  final String? category;
  final bool isActive;
  final DateTime createdAt;

  const SubscriptionModel({
    required this.id,
    required this.name,
    this.merchant,
    required this.amount,
    this.billingCycle = BillingCycle.monthly,
    required this.nextBillingDate,
    this.lastChargedDate,
    this.accountId,
    this.category,
    this.isActive = true,
    required this.createdAt,
  });

  double get monthlyEquivalent => switch (billingCycle) {
    BillingCycle.weekly => amount * 4.345,
    BillingCycle.monthly => amount,
    BillingCycle.quarterly => amount / 3,
    BillingCycle.yearly => amount / 12,
  };

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'merchant': merchant,
    'amount': amount,
    'billingCycle': billingCycle.name,
    'nextBillingDate': Timestamp.fromDate(nextBillingDate),
    'lastChargedDate': lastChargedDate == null
        ? null
        : Timestamp.fromDate(lastChargedDate!),
    'accountId': accountId,
    'category': category,
    'isActive': isActive,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory SubscriptionModel.fromJson(Map<String, dynamic> json) =>
      SubscriptionModel(
        id: json['id'] as String,
        name: json['name'] as String,
        merchant: json['merchant'] as String?,
        amount: (json['amount'] as num).toDouble(),
        billingCycle: BillingCycle.values.byName(
          json['billingCycle'] as String? ?? 'monthly',
        ),
        nextBillingDate: _toDate(json['nextBillingDate'])!,
        lastChargedDate: _toDate(json['lastChargedDate']),
        accountId: json['accountId'] as String?,
        category: json['category'] as String?,
        isActive: json['isActive'] as bool? ?? true,
        createdAt: _toDate(json['createdAt'])!,
      );

  factory SubscriptionModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return SubscriptionModel.fromJson({...data, 'id': doc.id});
  }

  SubscriptionModel copyWith({
    String? id,
    String? name,
    String? merchant,
    double? amount,
    BillingCycle? billingCycle,
    DateTime? nextBillingDate,
    DateTime? lastChargedDate,
    String? accountId,
    String? category,
    bool? isActive,
    DateTime? createdAt,
  }) => SubscriptionModel(
    id: id ?? this.id,
    name: name ?? this.name,
    merchant: merchant ?? this.merchant,
    amount: amount ?? this.amount,
    billingCycle: billingCycle ?? this.billingCycle,
    nextBillingDate: nextBillingDate ?? this.nextBillingDate,
    lastChargedDate: lastChargedDate ?? this.lastChargedDate,
    accountId: accountId ?? this.accountId,
    category: category ?? this.category,
    isActive: isActive ?? this.isActive,
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
