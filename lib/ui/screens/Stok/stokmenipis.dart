import 'package:aplikasipembukuanumkm/ui/screens/Stok/addstok.dart';
import 'package:aplikasipembukuanumkm/ui/screens/Stok/mainstok.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

const List<String> list = <String>[
  'Semua',
  'Makanan',
  'Minuman',
  'Bahan Pokok'
];

class StokMenipis extends StatefulWidget {
  const StokMenipis({super.key});

  @override
  State<StokMenipis> createState() => _StokMenipisState();
}

class _StokMenipisState extends State<StokMenipis> {
  String dropdownValue = list.first;
  TextEditingController stockController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Stok Barang',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Column(
        children: [
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      elevation: MaterialStatePropertyAll(0)),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Column(
                    children: [
                      Text(
                        'Semua Barang',
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      )
                    ],
                  )),
              ElevatedButton(
                  style: ButtonStyle(
                      backgroundColor:
                          MaterialStatePropertyAll(Colors.transparent),
                      elevation: MaterialStatePropertyAll(0)),
                  onPressed: () {},
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 6),
                        child: Text('Stok Menipis',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w400,
                                color: Colors.black)),
                      )
                    ],
                  ))
            ],
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Container(
                width: 200,
                height: 2,
                color: Colors.black,
              )
            ],
          ),
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                DropdownMenu<String>(
                  width: 250,
                  initialSelection: list.first,
                  label: Text('Kategori Barang'),
                  onSelected: (String? value) {
                    // This is called when the user selects an item.
                    setState(() {
                      dropdownValue = value!;
                    });
                  },
                  dropdownMenuEntries:
                      list.map<DropdownMenuEntry<String>>((String value) {
                    return DropdownMenuEntry<String>(
                        value: value, label: value);
                  }).toList(),
                ),
                ElevatedButton(
                    onPressed: () {},
                    child: Row(
                      children: [Icon(Icons.search)],
                    ))
              ],
            ),
          ),
          Expanded(
            child: StreamBuilder<Object>(
              stream:
                  FirebaseFirestore.instance.collection('barang').snapshots(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    (snapshot.data! as QuerySnapshot).docs.isEmpty) {
                  return Center(
                    child: Text('No data available'),
                  );
                }

                final documents = (snapshot.data! as QuerySnapshot).docs;
                return ListView.builder(
                  itemCount: documents.length,
                  itemBuilder: (context, index) {
                    var document = documents[index];
                    var nama = document['nama'];
                    var harga = document['harga_jual'];
                    var stok = document['stok_saatini'];
                    var stok_minimum = document['stok_minimum'];
                    return Column(
                      children: [
                        if (stok < stok_minimum) ...[
                          SizedBox(height: 20),
                          Container(
                            color: Colors.black,
                            width: double.infinity,
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 25, vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '$nama',
                                      style: TextStyle(
                                          fontWeight: FontWeight.w500,
                                          fontSize: 18),
                                    ),
                                    Text('Harga Jual'),
                                    Text('Rp $harga/pcs')
                                  ],
                                ),
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      style: ButtonStyle(
                                        backgroundColor:
                                            MaterialStatePropertyAll(
                                                Colors.amber),
                                      ),
                                      onPressed: () {
                                        _showStockDialog(nama, document.id);
                                      },
                                      child: Text(
                                        'Atur Stok',
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    Text('Stok : $stok')
                                  ],
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 5),
                          Container(
                            color: Colors.black,
                            width: double.infinity,
                            height: 2,
                          ),
                        ],
                      ],
                    );
                  },
                );
              },
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.amber,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => AddStock()));
          },
          label: Row(
            children: [Icon(Icons.add), Text('Tambah Barang')],
          )),
    );
  }

  void _showStockDialog(String nama, String documentId) {
    int newStock = 0; // Initialize with the current stock value

    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Atur Stok untuk $nama',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 10),
                  Row(
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            newStock = (newStock - 1).clamp(
                                0, 999); // Ensure the stock doesn't go below 0
                          });
                        },
                        child: Icon(Icons.remove),
                      ),
                      SizedBox(width: 10),
                      Text(
                        '$newStock',
                        style: TextStyle(fontSize: 16),
                      ),
                      SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            newStock = (newStock + 1).clamp(0,
                                999); // Limit the stock to a maximum value (e.g., 999)
                          });
                        },
                        child: Icon(Icons.add),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStatePropertyAll(Colors.amber)),
                    onPressed: () async {
                      QuerySnapshot querySnapshot = await FirebaseFirestore
                          .instance
                          .collection('barang')
                          .where('nama', isEqualTo: nama)
                          .get();

                      if (querySnapshot.docs.isNotEmpty) {
                        // There should be only one document with the specified 'nama'
                        String docId = querySnapshot.docs[0].id;

                        await FirebaseFirestore.instance
                            .collection('barang')
                            .doc(documentId)
                            .update({
                          'stok_saatini': FieldValue.increment(newStock),
                        });
                      } else {
                        // Handle the case where no document is found with the specified 'nama'
                        print('Document with nama $nama not found.');
                      }
                      // Update the stock value in Firestore
                      // Close the bottom sheet
                      Navigator.pop(context);
                    },
                    child: Text('Simpan'),
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
