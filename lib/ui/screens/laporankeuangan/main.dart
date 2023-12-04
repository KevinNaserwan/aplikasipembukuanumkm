import 'dart:io';
import 'package:aplikasipembukuanumkm/ui/screens/catatpembukuan/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';

class LaporanKeuangan extends StatefulWidget {
  const LaporanKeuangan({super.key});

  @override
  State<LaporanKeuangan> createState() => _LaporanKeuanganState();
}

class _LaporanKeuanganState extends State<LaporanKeuangan> {
  QuerySnapshot? savedSnapshot;
  String selectedOption = 'Semua'; // Default option
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  String selectedStartDateString = 'Pilih Tanggal';
  String selectedEndDateString = 'Pilih Tanggal';

  String selectedMonthString = 'Bulan';

  double totalPemasukan = 0;
  double totalPengeluaran = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Laporan Keuangan',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          child: Column(
            children: [
              SizedBox(height: 20),
              StreamBuilder<QuerySnapshot>(
                  stream: FirebaseFirestore.instance
                      .collection('pembukuan')
                      // .where('role', isEqualTo: 'Pemasukan')
                      .snapshots(),
                  builder: (context, snapshot) {
                    // Calculate the sum of 'jumlah' field
                    totalPemasukan = 0;
                    totalPengeluaran = 0;
                    if (snapshot.hasData) {
                      final documents = snapshot.data!.docs;
                      for (var document in documents) {
                        totalPemasukan += document['Total_pemasukan'];
                        totalPengeluaran += document['total_pengeluaran'];
                      }
                    }
                    return Padding(
                      padding: EdgeInsets.symmetric(horizontal: 15),
                      child: Container(
                        decoration: BoxDecoration(
                            border: Border.all(color: Colors.black)),
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
                                        totalPemasukan +=
                                            document['Total_pemasukan'];
                                      }
                                    }
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                          right: 40,
                                          left: 40,
                                          top: 14,
                                          bottom: 0),
                                      child: StreamBuilder<QuerySnapshot>(
                                          stream: FirebaseFirestore.instance
                                              .collection('pembukuan')
                                              // .where('role', isEqualTo: 'Pengeluaran')
                                              .snapshots(),
                                          builder: (context, snapshot) {
                                            // Calculate the sum of 'jumlah' field
                                            double totalPengeluaran = 0;
                                            if (snapshot.hasData) {
                                              final documents =
                                                  snapshot.data!.docs;
                                              for (var document in documents) {
                                                totalPengeluaran +=
                                                    document['total_pengeluaran'];
                                              }
                                            }
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceAround,
                                              children: [
                                                Text(
                                                  totalPemasukan >=
                                                          totalPengeluaran
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
                    );
                  }),
              GestureDetector(
                onTap: () {},
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Row(
                          children: [
                            Text('Pilih Tanggal Laporan'),
                            SizedBox(width: 30),
                            Container(
                              width: 181,
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              decoration: BoxDecoration(
                                border: Border.all(
                                    color: Colors.black), // Border warna hitam
                                borderRadius: BorderRadius.circular(
                                    0), // Sudut border yang melengkung
                              ),
                              child: DropdownButton<String>(
                                underline: Container(),
                                value: selectedOption,
                                onChanged: (String? newValue) {
                                  setState(() {
                                    selectedOption = newValue!;
                                  });
                                },
                                items: [
                                  'Semua',
                                  'Hari Ini',
                                  '7 Hari Terakhir',
                                  '30 Hari Terakhir',
                                  'Pilih Tanggal',
                                  'Rentang Tanggal',
                                ].map<DropdownMenuItem<String>>((String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 15),
                child: Container(
                  decoration:
                      BoxDecoration(border: Border.all(color: Colors.black)),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal Mulai'),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      elevation: MaterialStatePropertyAll(0),
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  onPressed: () =>
                                      _selectDate(context, true, false),
                                  child: Text(selectedStartDateString),
                                ),
                              ],
                            ),
                            Container(color: Colors.black, width: 30, height: 2),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Tanggal Selesai'),
                                SizedBox(height: 10),
                                ElevatedButton(
                                  style: ButtonStyle(
                                      elevation: MaterialStatePropertyAll(0),
                                      backgroundColor: MaterialStatePropertyAll(
                                          Colors.transparent)),
                                  onPressed: () =>
                                      _selectDate(context, false, false),
                                  child: Text(selectedEndDateString),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(height: 20),
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
      
                  List<DocumentSnapshot> documents = snapshot.data?.docs ?? [];
                  // Store snapshot for later use
                  savedSnapshot = snapshot.data;
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
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          _generatePDF();
        },
        label: Text(
          'Unduh Laporan',
          style: TextStyle(color: Colors.black),
        ),
        icon: Icon(Icons.download, color: Colors.black),
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

  Future<void> _selectDate(
      BuildContext context, bool isStartDate, bool isMonth) async {
    DateTime currentDate = isStartDate ? selectedStartDate : selectedEndDate;

    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null && picked != currentDate) {
      String formattedDate;

      if (isMonth) {
        formattedDate = DateFormat('MMMM yyyy').format(picked);
        setState(() {
          selectedMonthString = formattedDate;
        });
      } else {
        formattedDate = DateFormat('dd/MM/yyyy').format(picked);
        setState(() {
          if (isStartDate) {
            selectedStartDate = picked;
            selectedStartDateString = formattedDate;
          } else {
            selectedEndDate = picked;
            selectedEndDateString = formattedDate;
          }
        });
      }
    }
  }

  Future<void> _generatePDF() async {
    final pdf = pw.Document();

    // Tambahkan halaman PDF
    pdf.addPage(
      pw.Page(
        build: (context) {
          var snapshot;
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Tambahkan teks Laporan Pemasukan/Pengeluaran
              pw.Text(
                'Laporan Pemasukan/Pengeluaran',
                style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
              ),
              pw.SizedBox(height: 10),

              // Tambahkan teks Tanggal
              pw.Text(
                'Tanggal: $selectedStartDateString - $selectedEndDateString',
              ),
              pw.SizedBox(height: 10),

              // Tambahkan teks Jumlah transaksi
              pw.Text(
                'Jumlah Transaksi: ${savedSnapshot?.docs.length ?? 0}',
              ),
              pw.SizedBox(height: 10),

              // Tambahkan teks Total Pemasukan
              pw.Text(
                'Total Pemasukan: Rp $totalPemasukan',
              ),
              pw.SizedBox(height: 10),

              // Tambahkan teks Total Pengeluaran
              pw.Text(
                'Total Pengeluaran: Rp $totalPengeluaran',
              ),
              pw.SizedBox(height: 10),

              // Tambahkan teks Untung
              pw.Text(
                'Untung: Rp  ${((totalPemasukan - totalPengeluaran))}',
              ),
              pw.SizedBox(height: 20),

              // Tambahkan tabel dengan 5 kolom
              pw.Table(
                border: pw.TableBorder.all(),
                columnWidths: {
                  0: pw.IntrinsicColumnWidth(),
                  1: pw.IntrinsicColumnWidth(),
                  2: pw.IntrinsicColumnWidth(),
                  3: pw.IntrinsicColumnWidth(),
                  4: pw.IntrinsicColumnWidth(),
                },
                children: [
                  // Tambahkan header tabel
                  pw.TableRow(
                    children: [
                      pw.Text(' No',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(' Kategori',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(' Produk',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(' Pemasukan',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(' Pengeluaran',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  for (int i = 0; i < savedSnapshot!.docs.length; i++)
                    pw.TableRow(
                      children: [
                        pw.Text((i + 1).toString()), // No
                        pw.Text(
                            savedSnapshot!.docs[i]['role'] ?? ''), // Kategori
                        pw.Text(
                            savedSnapshot!.docs[i]['barang'] ?? ''), // Produk
                        pw.Text(
                            'Rp ${savedSnapshot!.docs[i]['Total_pemasukan'] ?? 0}'), // Pemasukan
                        pw.Text(
                            'Rp ${savedSnapshot!.docs[i]['total_pengeluaran'] ?? 0}'), // Pengeluaran
                      ],
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );

    // Simpan PDF ke penyimpanan lokal
    final directory = await getExternalStorageDirectory();
    final String path = '${directory!.path}/laporan_keuangan.pdf';
    final File file = File(path);
    await file.writeAsBytes(await pdf.save());

    // Buka PDF menggunakan aplikasi eksternal
    OpenFile.open(file.path);
  }
}
