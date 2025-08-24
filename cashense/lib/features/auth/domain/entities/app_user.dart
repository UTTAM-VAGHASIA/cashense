class AppUser {
  final String uid;
  final String email;
  final String photoUrl;


  AppUser({required this.uid, required this.email, required this.photoUrl});

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'profileImageUrl': photoUrl,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      email: json['email'],
      photoUrl: json['photoUrl'],
    );
  }
}
