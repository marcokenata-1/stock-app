import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:stock_app/DataLayer/user_symbol.dart';

class DatabaseService {
  final FirebaseFirestore db = FirebaseFirestore.instance;

  addUserData(UserSymbol data) async {
    await db.collection('users').doc(data.uid).set(data.toMap());
  }

  Future<List<UserSymbol>> retreiveUserData(String email) async {
    QuerySnapshot<Map<String, dynamic>> snapshot =
        await db.collection("users").where('email', isEqualTo: email).get();
    return snapshot.docs
        .map((docSnapshot) => UserSymbol.fromDocumentSnapshot(docSnapshot))
        .toList();
  }

  deleteUserData(String email, String symbol) async {
    QuerySnapshot<Map<String, dynamic>> snapshot = await db
        .collection("users")
        .where('email', isEqualTo: email)
        .where('symbol', isEqualTo: symbol)
        .get();
    UserSymbol instance = snapshot.docs
        .map((docSnapshot) => UserSymbol.fromDocumentSnapshot(docSnapshot))
        .first;
    await db.collection('users').doc(instance.uid).delete();
  }
}
