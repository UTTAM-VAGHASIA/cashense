import 'package:cloud_firestore/cloud_firestore.dart';

/// Per-member balance document inside `groups/{groupId}/balances/{uid}`.
/// Tracks how much this member owes others and how much others owe them.
class DebtModel {
  final String uid;
  final Map<String, double> owes;
  final Map<String, double> isOwed;
  final DateTime lastUpdated;

  const DebtModel({
    required this.uid,
    this.owes = const {},
    this.isOwed = const {},
    required this.lastUpdated,
  });

  double get totalOwed => owes.values.fold(0, (acc, v) => acc + v);
  double get totalIsOwed => isOwed.values.fold(0, (acc, v) => acc + v);
  double get netBalance => totalIsOwed - totalOwed;

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'owes': owes,
    'isOwed': isOwed,
    'lastUpdated': Timestamp.fromDate(lastUpdated),
  };

  factory DebtModel.fromJson(Map<String, dynamic> json) => DebtModel(
    uid: json['uid'] as String,
    owes:
        (json['owes'] as Map?)?.map(
          (k, v) => MapEntry(k as String, (v as num).toDouble()),
        ) ??
        const {},
    isOwed:
        (json['isOwed'] as Map?)?.map(
          (k, v) => MapEntry(k as String, (v as num).toDouble()),
        ) ??
        const {},
    lastUpdated: _toDate(json['lastUpdated'])!,
  );

  factory DebtModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return DebtModel.fromJson({...data, 'uid': doc.id});
  }

  DebtModel copyWith({
    String? uid,
    Map<String, double>? owes,
    Map<String, double>? isOwed,
    DateTime? lastUpdated,
  }) => DebtModel(
    uid: uid ?? this.uid,
    owes: owes ?? this.owes,
    isOwed: isOwed ?? this.isOwed,
    lastUpdated: lastUpdated ?? this.lastUpdated,
  );
}

DateTime? _toDate(dynamic v) {
  if (v == null) return null;
  if (v is Timestamp) return v.toDate();
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  return null;
}
