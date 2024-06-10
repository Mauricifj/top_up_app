class Beneficiary {
  final String uid;
  final String nickname;
  final String phone;

  Beneficiary({
    required this.uid,
    required this.nickname,
    required this.phone,
  });

  Beneficiary copyWith({
    String? uid,
    String? nickname,
    String? phone,
  }) {
    return Beneficiary(
      uid: uid ?? this.uid,
      nickname: nickname ?? this.nickname,
      phone: phone ?? this.phone,
    );
  }
}
