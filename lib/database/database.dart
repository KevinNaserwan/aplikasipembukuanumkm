import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseMethods {
  Future addHutangDetails(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("catatan_hutang")
        .doc()
        .set(userInfoMap);
  }

  Future addbarang(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("barang")
        .doc()
        .set(userInfoMap);
  }

  
  Future addPembukuan(Map<String, dynamic> userInfoMap) async {
    return await FirebaseFirestore.instance
        .collection("pembukuan")
        .doc()
        .set(userInfoMap);
  }
}
