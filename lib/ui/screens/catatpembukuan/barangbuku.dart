import 'package:aplikasipembukuanumkm/ui/screens/Stok/addstok.dart';
import 'package:aplikasipembukuanumkm/ui/screens/catatpembukuan/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class BarangBuku extends StatefulWidget {
  const BarangBuku({super.key});

  @override
  State<BarangBuku> createState() => _BarangBukuState();
}

class _BarangBukuState extends State<BarangBuku> {
  Map<String, int> selectedItems = {};
  Map<String, Map<String, dynamic>> selectedItemsDetails = {};

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Daftar Barang',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStatePropertyAll(0),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.transparent)),
                        onPressed: () {},
                        child: Text('Cari Barang')),
                  ),
                  Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStatePropertyAll(0),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.transparent)),
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (context) => AddStock()));
                        },
                        child: Text('Tambah Barang')),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            Divider(
              thickness: 3,
              color: Colors.black,
            ),
            StreamBuilder<QuerySnapshot>(
              stream:
                  FirebaseFirestore.instance.collection('barang').snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                if (!snapshot.hasData) {
                  return CircularProgressIndicator();
                }

                // Extract the documents from snapshot
                var documents = snapshot.data!.docs;

                return Column(
                  children: [
                    for (var doc in documents)
                      ListTile(
                        title: Text(doc['nama']),
                        subtitle: Text(
                          'Stok: ${doc['stok_saatini']}, Kategori: ${doc['kategori']}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Checkbox(
                              value: selectedItems.containsKey(doc.id),
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value!) {
                                    selectedItems[doc.id] = 0;
                                    selectedItemsDetails[doc.id] = {
                                      'harga_jual': doc['harga_jual'],
                                      'harga_modal': doc['harga_modal'],
                                    };
                                  } else {
                                    selectedItems.remove(doc.id);
                                    selectedItemsDetails.remove(doc.id);
                                  }
                                });
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.add),
                              onPressed: () {
                                setState(() {
                                  selectedItems[doc.id] =
                                      (selectedItems[doc.id] ?? 0) + 1;
                                });
                              },
                            ),
                            Text('${selectedItems[doc.id] ?? 0}'),
                            IconButton(
                              icon: Icon(Icons.remove),
                              onPressed: () {
                                setState(() {
                                  if (selectedItems[doc.id] != null &&
                                      selectedItems[doc.id]! > 0) {
                                    selectedItems[doc.id] =
                                        selectedItems[doc.id]! - 1;
                                  }
                                });
                              },
                            ),
                          ],
                        ),
                      ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Container(
                  width: double.infinity,
                  child: ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.amber)),
                      onPressed: () {
                        saveSelectedItems();
                        Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => CatatanPembukuan(
                            selectedItemsDetails: selectedItemsDetails,
                          ),
                        ));
                      },
                      child: Text('Simpan'))),
            )
          ],
        ),
      ),
    );
  }

  void saveSelectedItems() {
    // Iterate over selectedItems and update Firestore
    selectedItems.forEach((docId, quantity) {
      FirebaseFirestore.instance.collection('barang').doc(docId).update({
        'stok_saatini': FieldValue.increment(-quantity),
      });

      // Calculate total price for each selected item
      int hargaJual = selectedItemsDetails[docId]!['harga_jual'];
      int hargaModal = selectedItemsDetails[docId]!['harga_modal'];
      int totalHargaJual = hargaJual * quantity;
      int totalHargaModal = hargaModal * quantity;

      // Save the calculated totals along with the quantity
      selectedItemsDetails[docId]!['quantity'] = quantity;
      selectedItemsDetails[docId]!['total_harga_jual'] = totalHargaJual;
      selectedItemsDetails[docId]!['total_harga_modal'] = totalHargaModal;
    });

    // Clear the local state after saving to Firestore
    setState(() {
      selectedItems = {};
      selectedItemsDetails = {};
    });
  }
}
