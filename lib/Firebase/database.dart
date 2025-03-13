// import 'package:cloud_firestore/cloud_firestore.dart';
//
//
// class DatabaseService {
//   final CollectionReference _accountsCollection =
//   FirebaseFirestore.instance.collection('accounts');
//
//   Stream<List<Account>> getAccountList() {
//     return _accountsCollection.snapshots().map((snapshot) => snapshot.docs
//         .map((doc) => Account.fromFirestore(doc))
//         .toList());
//   }
//   Future<List<Account>> searchAccounts(String keyword) async {
//     QuerySnapshot snapshot = await _accountsCollection
//         .where('username', isGreaterThanOrEqualTo: keyword)
//         .where('username', isLessThan: keyword + 'z')
//         .get();
//
//     return snapshot.docs.map((doc) => Account.fromFirestore(doc)).toList();
//
//
//   }
// }