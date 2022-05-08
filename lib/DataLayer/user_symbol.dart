import 'package:cloud_firestore/cloud_firestore.dart';

class UserSymbol {
  String? uid;
  final String? email;
  final String? symbol;

  UserSymbol({this.uid, this.email, this.symbol});

  Map<String, dynamic> toMap() {
    return {'email': email, 'symbol': symbol};
  }

  UserSymbol.fromDocumentSnapshot(DocumentSnapshot<Map<String, dynamic>> doc)
      : uid = doc.id,
        email = doc.data()!["email"],
        symbol = doc.data()!["symbol"];
}
