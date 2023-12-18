class Wallet {
  String? id;
  int? balance;
  String? bankName;
  String? bankAccount;

  Wallet({this.id, this.balance, this.bankName, this.bankAccount});

  Wallet.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    balance = json['balance'];
    bankName = json['bankName'];
    bankAccount = json['bankAccount'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['balance'] = this.balance;
    data['bankName'] = this.bankName;
    data['bankAccount'] = this.bankAccount;
    return data;
  }
}
