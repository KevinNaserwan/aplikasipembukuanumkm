import 'package:aplikasipembukuanumkm/ui/screens/catatpembukuan/main.dart';
import 'package:aplikasipembukuanumkm/ui/screens/laporankeuangan/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ListPembukuan extends StatefulWidget {
  const ListPembukuan({super.key});

  @override
  State<ListPembukuan> createState() => _ListPembukuanState();
}

class _ListPembukuanState extends State<ListPembukuan> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Catatan Pembukuan',
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
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 25),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('pembukuan')
                                  // .where('role', isEqualTo: 'Pemasukan')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                // Calculate the sum of 'jumlah' field
                                double totalPemasukan = 0;
                                if (snapshot.hasData) {
                                  final documents = snapshot.data!.docs;
                                  for (var document in documents) {
                                    totalPemasukan +=
                                        document['Total_pemasukan'];
                                  }
                                }
                                return Column(
                                  children: [
                                    Text('Rp $totalPemasukan'),
                                    Text('Penjualan')
                                  ],
                                );
                              }),
                          StreamBuilder<QuerySnapshot>(
                              stream: FirebaseFirestore.instance
                                  .collection('pembukuan')
                                  // .where('role', isEqualTo: 'Pengeluaran')
                                  .snapshots(),
                              builder: (context, snapshot) {
                                // Calculate the sum of 'jumlah' field
                                double totalPengeluaran = 0;
                                if (snapshot.hasData) {
                                  final documents = snapshot.data!.docs;
                                  for (var document in documents) {
                                    totalPengeluaran +=
                                        document['total_pengeluaran'];
                                  }
                                }
                                return Column(
                                  children: [
                                    Text('Rp $totalPengeluaran'),
                                    Text('Pengeluaran')
                                  ],
                                );
                              })
                        ],
                      ),
                      SizedBox(height: 20),
                      Divider(
                        color: Colors.black,
                        thickness: 2,
                      ),
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('pembukuan')
                              // .where('role', isEqualTo: 'Pemasukan')
                              .snapshots(),
                          builder: (context, snapshot) {
                            // Calculate the sum of 'jumlah' field
                            double totalPemasukan = 0;
                            if (snapshot.hasData) {
                              final documents = snapshot.data!.docs;
                              for (var document in documents) {
                                totalPemasukan += document['Total_pemasukan'];
                              }
                            }
                            return Padding(
                              padding: const EdgeInsets.only(
                                  right: 40, left: 40, top: 14, bottom: 0),
                              child: StreamBuilder<QuerySnapshot>(
                                  stream: FirebaseFirestore.instance
                                      .collection('pembukuan')
                                      // .where('role', isEqualTo: 'Pengeluaran')
                                      .snapshots(),
                                  builder: (context, snapshot) {
                                    // Calculate the sum of 'jumlah' field
                                    double totalPengeluaran = 0;
                                    if (snapshot.hasData) {
                                      final documents = snapshot.data!.docs;
                                      for (var document in documents) {
                                        totalPengeluaran +=
                                            document['total_pengeluaran'];
                                      }
                                    }
                                    return Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          totalPemasukan >= totalPengeluaran
                                              ? 'Untung'
                                              : 'Rugi',
                                        ),
                                        Text(
                                          'Rp ${((totalPemasukan - totalPengeluaran).abs())}',
                                        ),
                                      ],
                                    );
                                  }),
                            );
                          }),
                    ],
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => LaporanKeuangan()));
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Row(
                      children: [
                        Icon(Icons.bar_chart),
                        Text('Laporan Keuangan')
                      ],
                    ),
                    Icon(Icons.keyboard_double_arrow_right_sharp)
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pembukuan')
                    .where('role', isEqualTo: 'Pemasukan')
                    .snapshots(),
                builder: (context, snapshot) {
                  // Calculate the sum of 'jumlah' field
                  double totalPemasukan = 0;
                  if (snapshot.hasData) {
                    final documents = snapshot.data!.docs;
                    for (var document in documents) {
                      totalPemasukan += document['Total_pemasukan'];
                    }
                  }
                  return Column(
                    children: [
                      StreamBuilder<QuerySnapshot>(
                          stream: FirebaseFirestore.instance
                              .collection('pembukuan')
                              .where('role', isEqualTo: 'Pengeluaran')
                              .snapshots(),
                          builder: (context, snapshot) {
                            // Calculate the sum of 'jumlah' field
                            double totalPengeluaran = 0;
                            if (snapshot.hasData) {
                              final documents = snapshot.data!.docs;
                              for (var document in documents) {
                                totalPengeluaran +=
                                    document['total_pengeluaran'];
                              }
                            }
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Text(
                                  '${DateTime.now().day} ${_getShortMonthName(DateTime.now().month)} ${DateTime.now().year}', // Format tanggal
                                ),
                                Text(
                                  totalPemasukan >= totalPengeluaran
                                      ? 'Untung '
                                          'Rp ${((totalPemasukan - totalPengeluaran).abs())}'
                                      : 'Rugi '
                                          'Rp ${((totalPemasukan - totalPengeluaran).abs())}',
                                ),
                              ],
                            );
                          }),
                    ],
                  );
                }),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Divider(
                thickness: 1,
                color: Colors.black,
              ),
            ),
            StreamBuilder<QuerySnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('pembukuan')
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CircularProgressIndicator(); // or some loading indicator
                }

                if (snapshot.hasError) {
                  return Text('Error: ${snapshot.error}');
                }

                List<DocumentSnapshot> documents = snapshot.data!.docs;
                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: DataTable(
                      columnSpacing: 45.0,
                      columns: [
                        DataColumn(label: Text('Catatan')),
                        DataColumn(label: Text('Penjualan')),
                        DataColumn(label: Text('Pengeluaran')),
                      ],
                      rows: List.generate(documents.length, (index) {
                        var document = documents[index];
                        return DataRow(cells: [
                          DataCell(Text(document['role'] ?? '')),
                          DataCell(
                              Text('Rp ${document['Total_pemasukan'] ?? 0}')),
                          DataCell(
                              Text('Rp ${document['total_pengeluaran'] ?? 0}')),
                        ]);
                      }),
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) =>
                  CatatanPembukuan(selectedItemsDetails: {})));
        },
        label: Text(
          'Tambah Catatan',
          style: TextStyle(color: Colors.black),
        ),
        icon: Icon(Icons.add, color: Colors.black),
        backgroundColor: Colors.amber,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  String _getShortDayName(int day) {
    List<String> days = ['Monday', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return days[day - 1];
  }

  String _getShortMonthName(int month) {
    List<String> months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return months[month - 1];
  }
}
