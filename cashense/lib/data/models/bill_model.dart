import 'package:cloud_firestore/cloud_firestore.dart';

enum BillType { subscription, rent, emi, utility, insurance, custom }

enum BillStatus { pending, paid, overdue }

class BillModel {
  final String id;
  final String name;
  final BillType type;
  final double amount;
  final int dueDay;
  final bool isRecurring;
  final DateTime? lastPaidDate;
  final DateTime nextDueDate;
  final BillStatus status;
  final String? accountId;
  final List<int> remindDaysBefore;
  final DateTime createdAt;

  const BillModel({
    required this.id,
    required this.name,
    this.type = BillType.custom,
    required this.amount,
    required this.dueDay,
    this.isRecurring = true,
    this.lastPaidDate,
    required this.nextDueDate,
    this.status = BillStatus.pending,
    this.accountId,
    this.remindDaysBefore = const [7, 1],
    required this.createdAt,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'amount': amount,
    'dueDay': dueDay,
    'isRecurring': isRecurring,
    'lastPaidDate': lastPaidDate == null
        ? null
        : Timestamp.fromDate(lastPaidDate!),
    'nextDueDate': Timestamp.fromDate(nextDueDate),
    'status': status.name,
    'accountId': accountId,
    'remindDaysBefore': remindDaysBefore,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  factory BillModel.fromJson(Map<String, dynamic> json) => BillModel(
    id: json['id'] as String,
    name: json['name'] as String,
    type: BillType.values.byName(json['type'] as String? ?? 'custom'),
    amount: (json['amount'] as num).toDouble(),
    dueDay: json['dueDay'] as int,
    isRecurring: json['isRecurring'] as bool? ?? true,
    lastPaidDate: _toDate(json['lastPaidDate']),
    nextDueDate: _toDate(json['nextDueDate'])!,
    status: BillStatus.values.byName(json['status'] as String? ?? 'pending'),
    accountId: json['accountId'] as String?,
    remindDaysBefore:
        (json['remindDaysBefore'] as List?)?.cast<int>() ?? const [7, 1],
    createdAt: _toDate(json['createdAt'])!,
  );

  factory BillModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BillModel.fromJson({...data, 'id': doc.id});
  }

  BillModel copyWith({
    String? id,
    String? name,
    BillType? type,
    double? amount,
    int? dueDay,
    bool? isRecurring,
    DateTime? lastPaidDate,
    DateTime? nextDueDate,
    BillStatus? status,
    String? accountId,
    List<int>? remindDaysBefore,
    DateTime? createdAt,
  }) => BillModel(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    amount: amount ?? this.amount,
    dueDay: dueDay ?? this.dueDay,
    isRecurring: isRecurring ?? this.isRecurring,
    lastPaidDate: lastPaidDate ?? this.lastPaidDate,
    nextDueDate: nextDueDate ?? this.nextDueDate,
    status: status ?? this.status,
    accountId: accountId ?? this.accountId,
    remindDaysBefore: remindDaysBefore ?? this.remindDaysBefore,
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
