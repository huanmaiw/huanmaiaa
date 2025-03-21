class Account {
  final String account;
  final String password;

  Account({required this.account, required this.password});

  factory Account.fromJson(Map<String, dynamic> json) {
    return Account(
      account: json['account'],
      password: json['password'],
    );
  }
}