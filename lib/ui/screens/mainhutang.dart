import 'package:aplikasipembukuanumkm/ui/screens/catathutang.dart';
import 'package:aplikasipembukuanumkm/ui/screens/detail.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainHutang extends StatefulWidget {
  const MainHutang({super.key});

  @override
  State<MainHutang> createState() => _MainHutangState();
}

class _MainHutangState extends State<MainHutang> {
  void _navigateToHutangDetail(BuildContext context, String formattedDate,
      String pelanggan, int hutangDibayar, String role) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => HutangDetail(
            formattedDate: formattedDate,
            pelanggan: pelanggan,
            hutangDibayar: hutangDibayar,
            role: role),
      ),
    );
  }

  final FirebaseFirestore firestore = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      color: Colors.blue.shade200,
                      borderRadius: BorderRadius.circular(5)),
                  child: Padding(
                    padding: const EdgeInsets.only(
                        left: 50, right: 50, top: 30, bottom: 30),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('catatan_hutang')
                                .where('role', isEqualTo: 'Memberi')
                                .snapshots(),
                            builder: (context, snapshot) {
                              // Calculate the sum of 'jumlah' field
                              double totalJumlah = 0;
                              if (snapshot.hasData) {
                                final documents = snapshot.data!.docs;
                                for (var document in documents) {
                                  totalJumlah += document['Jumlah'];
                                }
                              }
                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                      width: 120,
                                      child: Text(
                                        'Utang sudah dibayar',
                                        textAlign: TextAlign.center,
                                      )),
                                  Text('Rp $totalJumlah')
                                ],
                              );
                            }),
                        StreamBuilder<QuerySnapshot>(
                            stream: FirebaseFirestore.instance
                                .collection('catatan_hutang')
                                .where('role', isEqualTo: 'Menerima')
                                .snapshots(),
                            builder: (context, snapshot) {
                              // Calculate the sum of 'jumlah' field
                              double totalJumlah = 0;
                              if (snapshot.hasData) {
                                final documents = snapshot.data!.docs;
                                for (var document in documents) {
                                  totalJumlah += document['Jumlah'];
                                }
                              }

                              {
                                return Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                        width: 160,
                                        child: Text(
                                          'Total Pembayaran Utang',
                                          textAlign: TextAlign.center,
                                        )),
                                    Text('Rp $totalJumlah')
                                  ],
                                );
                              }
                            })
                      ],
                    ),
                  ))),
          SizedBox(height: 20),
          Expanded(
            child: StreamBuilder<Object>(
                stream: FirebaseFirestore.instance
                    .collection('catatan_hutang')
                    .snapshots(),
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
                        // Inside your build method where you get the 'Tanggal' value
                        var tanggal = documents[index];
                        var timestamp = (document['Tanggal'] as Timestamp)
                            .toDate(); // Convert timestamp to DateTime

// Now, you can format the DateTime object as a string
                        var formattedDate = DateFormat('dd-MM-yyyy')
                            .format(timestamp); // Customize the dat
                        var pelanggan = document['Pelanggan'];
                        var jumlah = document['Jumlah'];
                        var role = document['role'];
                        return Column(
                          children: [
                            SizedBox(height: 20),
                            ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor: MaterialStatePropertyAll(
                                      Colors.transparent),
                                  elevation: MaterialStatePropertyAll(0)),
                              onPressed: () {
                                _navigateToHutangDetail(
                                    context, formattedDate, pelanggan, jumlah, role);
                              },
                              child: Padding(
                                padding: EdgeInsets.symmetric(horizontal: 0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.blue.shade300),
                                  child: Padding(
                                    padding: const EdgeInsets.all(25.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Tanggal'),
                                            Text(formattedDate)
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text('Pelanggan'),
                                            Text(pelanggan)
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          height: 2,
                                          decoration: BoxDecoration(
                                              color: Colors.black),
                                        ),
                                        SizedBox(height: 10),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            if (role == 'Menerima')
                                              Text('Hutang Dibayar'),
                                            if (role == 'Memberi')
                                              Text('Berhutang Sebanyak'),
                                            Text('Rp $jumlah')
                                          ],
                                        ),
                                        SizedBox(height: 10),
                                        Container(
                                          width: double.infinity,
                                          height: 2,
                                          decoration: BoxDecoration(
                                              color: Colors.black),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        );
                      });
                }),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.amber,
          onPressed: () {
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (context) => HutangPage()));
          },
          label: Row(
            children: [Icon(Icons.add), Text('Tambah Catatan')],
          )),
    );
  }
}
