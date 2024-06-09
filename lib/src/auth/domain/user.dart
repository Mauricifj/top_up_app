class User {
  final String uid;
  final String email;
  final String displayName;
  final bool isVerified;

  User({
    required this.uid,
    required this.email,
    required this.displayName,
    this.isVerified = false,
  });

  User copyWith({
    String? uid,
    String? email,
    String? displayName,
    bool? isVerified,
  }) {
    return User(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      isVerified: isVerified ?? this.isVerified,
    );
  }
}
