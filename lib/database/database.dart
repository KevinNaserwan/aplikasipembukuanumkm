import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addHutangDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("catatan_hutang")
        .doc()
        .set(userInfoMap);
  }
}
