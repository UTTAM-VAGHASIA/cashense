import 'package:cloud_firestore/cloud_firestore.dart';

enum AccountType { bank, cash, upiWallet, creditCard }

extension AccountTypeX on AccountType {
  String toJson() => switch (this) {
    AccountType.bank => 'bank',
    AccountType.cash => 'cash',
    AccountType.upiWallet => 'upi_wallet',
    AccountType.creditCard => 'credit_card',
  };

  static AccountType fromJson(String value) => switch (value) {
    'bank' => AccountType.bank,
    'cash' => AccountType.cash,
    'upi_wallet' => AccountType.upiWallet,
    'credit_card' => AccountType.creditCard,
    _ => throw ArgumentError('Unknown AccountType: $value'),
  };
}

class AccountModel {
  final String id;
  final String name;
  final AccountType type;
  final double balance;
  final String currency;
  final String? color;
  final String? icon;
  final bool isDefault;
  final DateTime createdAt;
  final DateTime updatedAt;

  const AccountModel({
    required this.id,
    required this.name,
    required this.type,
    required this.balance,
    this.currency = 'INR',
    this.color,
    this.icon,
    this.isDefault = false,
    required this.createdAt,
    required this.updatedAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.toJson(),
    'balance': balance,
    'currency': currency,
    'color': color,
    'icon': icon,
    'isDefault': isDefault,
    'createdAt': Timestamp.fromDate(createdAt),
    'updatedAt': Timestamp.fromDate(updatedAt),
  };

  factory AccountModel.fromJson(Map<String, dynamic> json) => AccountModel(
    id: json['id'] as String,
    name: json['name'] as String,
    type: AccountTypeX.fromJson(json['type'] as String),
    balance: (json['balance'] as num).toDouble(),
    currency: json['currency'] as String? ?? 'INR',
    color: json['color'] as String?,
    icon: json['icon'] as String?,
    isDefault: json['isDefault'] as bool? ?? false,
    createdAt: _toDate(json['createdAt'])!,
    updatedAt: _toDate(json['updatedAt'])!,
  );

  factory AccountModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return AccountModel.fromJson({...data, 'id': doc.id});
  }

  AccountModel copyWith({
    String? id,
    String? name,
    AccountType? type,
    double? balance,
    String? currency,
    String? color,
    String? icon,
    bool? isDefault,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) => AccountModel(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    balance: balance ?? this.balance,
    currency: currency ?? this.currency,
    color: color ?? this.color,
    icon: icon ?? this.icon,
    isDefault: isDefault ?? this.isDefault,
    createdAt: createdAt ?? this.createdAt,
    updatedAt: updatedAt ?? this.updatedAt,
  );
}

DateTime? _toDate(dynamic v) {
  if (v == null) return null;
  if (v is Timestamp) return v.toDate();
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  return null;
}
