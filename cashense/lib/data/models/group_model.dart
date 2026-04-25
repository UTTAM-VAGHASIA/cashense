import 'package:cloud_firestore/cloud_firestore.dart';

enum GroupType { trip, roommates, couple, event, other }

class GroupModel {
  final String id;
  final String name;
  final GroupType type;
  final List<String> members;
  final Map<String, String> memberNames;
  final String createdBy;
  final DateTime createdAt;
  final bool isSettled;

  const GroupModel({
    required this.id,
    required this.name,
    this.type = GroupType.other,
    this.members = const [],
    this.memberNames = const {},
    required this.createdBy,
    required this.createdAt,
    this.isSettled = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'type': type.name,
    'members': members,
    'memberNames': memberNames,
    'createdBy': createdBy,
    'createdAt': Timestamp.fromDate(createdAt),
    'isSettled': isSettled,
  };

  factory GroupModel.fromJson(Map<String, dynamic> json) => GroupModel(
    id: json['id'] as String,
    name: json['name'] as String,
    type: GroupType.values.byName(json['type'] as String? ?? 'other'),
    members: (json['members'] as List?)?.cast<String>() ?? const [],
    memberNames:
        (json['memberNames'] as Map?)?.map(
          (k, v) => MapEntry(k as String, v as String),
        ) ??
        const {},
    createdBy: json['createdBy'] as String,
    createdAt: _toDate(json['createdAt'])!,
    isSettled: json['isSettled'] as bool? ?? false,
  );

  factory GroupModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return GroupModel.fromJson({...data, 'id': doc.id});
  }

  GroupModel copyWith({
    String? id,
    String? name,
    GroupType? type,
    List<String>? members,
    Map<String, String>? memberNames,
    String? createdBy,
    DateTime? createdAt,
    bool? isSettled,
  }) => GroupModel(
    id: id ?? this.id,
    name: name ?? this.name,
    type: type ?? this.type,
    members: members ?? this.members,
    memberNames: memberNames ?? this.memberNames,
    createdBy: createdBy ?? this.createdBy,
    createdAt: createdAt ?? this.createdAt,
    isSettled: isSettled ?? this.isSettled,
  );
}

DateTime? _toDate(dynamic v) {
  if (v == null) return null;
  if (v is Timestamp) return v.toDate();
  if (v is DateTime) return v;
  if (v is String) return DateTime.tryParse(v);
  return null;
}
