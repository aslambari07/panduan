class NeewsUser {
  final String id;
  final String uId;
  final String userName;
  final String email;
  final String language;
  final String verified;
  final String signUpVia;
  final String accountCreated;
  final String signedIn;
  final String lastActive;

  NeewsUser(
      {required this.id,
      required this.uId,
      required this.userName,
      required this.email,
      required this.language,
      required this.verified,
      required this.signUpVia,
      required this.accountCreated,
      required this.signedIn,
      required this.lastActive});

  factory NeewsUser.fromJson(Map<String, dynamic> json) {
    return NeewsUser(
        id: json['id'],
        uId: json['uId'],
        userName: json['user_name'],
        email: json['email'],
        language: json['language'],
        verified: json['verified'],
        signUpVia: json['sign_up_via'],
        accountCreated: json['account_created'],
        signedIn: json['signed_in'],
        lastActive: json['last_active']);
  }
}
