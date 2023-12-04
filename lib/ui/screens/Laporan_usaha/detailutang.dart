import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:open_file/open_file.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:path_provider/path_provider.dart';
import 'dart:typed_data';
import 'dart:io';

class DetailUtang extends StatefulWidget {
  const DetailUtang({super.key});

  @override
  State<DetailUtang> createState() => _DetailUtangState();
}

class _DetailUtangState extends State<DetailUtang> {
  QuerySnapshot? savedSnapshot;
  DateTime selectedStartDate = DateTime.now();
  DateTime selectedEndDate = DateTime.now();

  String selectedStartDateString = 'Pilih Tanggal';
  String selectedEndDateString = 'Pilih Tanggal';

  String selectedMonthString = 'Bulan';

  double totalJumlah = 0;
  double totalJumlah1 = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Laporan Utang',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
      body: Container(
        child: Column(
          children: [
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration:
                    BoxDecoration(border: Border.all(color: Colors.black)),
                child: StreamBuilder<QuerySnapshot>(
                    stream: FirebaseFirestore.instance
                        .collection('catatan_hutang')
                        .where('role', isEqualTo: 'Menerima')
                        .snapshots(),
                    builder: (context, snapshot) {
                      // Calculate the sum of 'jumlah' field
                      totalJumlah = 0;
                      if (snapshot.hasData) {
                        final documents = snapshot.data!.docs;
                        for (var document in documents) {
                          totalJumlah += document['Jumlah'];
                        }
                      }
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 30),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceAround,
                              children: [
                                Column(
                                  children: [
                                    Text('Rp $totalJumlah'),
                                    Text('Terima')
                                  ],
                                ),
                                StreamBuilder<QuerySnapshot>(
                                    stream: FirebaseFirestore.instance
                                        .collection('catatan_hutang')
                                        .where('role', isEqualTo: 'Memberi')
                                        .snapshots(),
                                    builder: (context, snapshot) {
                                      // Calculate the sum of 'jumlah' field
                                      totalJumlah1 = 0;
                                      if (snapshot.hasData) {
                                        final documents = snapshot.data!.docs;
                                        for (var document in documents) {
                                          totalJumlah1 += document['Jumlah'];
                                        }
                                      }
                                      return Column(
                                        children: [
                                          Text('Rp $totalJumlah1'),
                                          Text('Berikan')
                                        ],
                                      );
                                    })
                              ],
                            ),
                            SizedBox(height: 20),
                            StreamBuilder<QuerySnapshot>(
                                stream: FirebaseFirestore.instance
                                    .collection('catatan_hutang')
                                    .where('role', isEqualTo: 'Memberi')
                                    .snapshots(),
                                builder: (context, snapshot) {
                                  // Calculate the sum of 'jumlah' field
                                  double totalJumlah1 = 0;
                                  if (snapshot.hasData) {
                                    final documents = snapshot.data!.docs;
                                    for (var document in documents) {
                                      totalJumlah1 += document['Jumlah'];
                                    }
                                  }
                                  double sisaUtang = totalJumlah1 - totalJumlah;
                                  return Center(
                                    child: Text('Sisa Utang Rp $sisaUtang '),
                                  );
                                }),
                          ],
                        ),
                      );
                    }),
              ),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text('Pilih Tanggal'),
                  Container(
                    height: 40,
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(5)),
                    child: ElevatedButton(
                      style: ButtonStyle(
                          elevation: MaterialStatePropertyAll(0),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.transparent)),
                      onPressed: () => _selectDate(
                          context, true, true), // Function to show date picker
                      child: Text(selectedMonthString),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
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
                  .collection('catatan_hutang')
                  .where('Tanggal', isGreaterThanOrEqualTo: selectedStartDate)
                  .where('Tanggal', isLessThanOrEqualTo: selectedEndDate)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                List<DocumentSnapshot> documents = snapshot.data?.docs ?? [];
                // Store snapshot for later use
                savedSnapshot = snapshot.data;
                var data = snapshot.data!.docs;

                return Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Container(
                    decoration:
                        BoxDecoration(border: Border.all(color: Colors.black)),
                    child: DataTable(
                      columnSpacing: 15.0,
                      columns: [
                        DataColumn(label: Text('Rincian')),
                        DataColumn(label: Text('Utang Dibayar')),
                        DataColumn(label: Text('Utang Belum Dibayar')),
                      ],
                      rows: data.map<DataRow>((item) {
                        return DataRow(cells: [
                          DataCell(Text(item['Pelanggan'] ??
                              'Unknown')), // Replace 'Pelanggan' with your actual field
                          DataCell(Text((item['role'] == 'Menerima'
                                  ? item['Jumlah']
                                  : 0)
                              .toString())), // Replace 'Jumlah' with your actual field
                          DataCell(Text((item['role'] == 'Memberi'
                                  ? item['Jumlah']
                                  : 0)
                              .toString())), // Replace 'Jumlah' with your actual field
                        ]);
                      }).toList(),
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Add the functionality to download the report
          // You can implement the logic to generate and download the report here
          _generatePDF();
        },
        label: Text(
          'Unduh Laporan',
          style: TextStyle(color: Colors.black),
        ),
        icon: Icon(Icons.download_rounded, color: Colors.black),
        backgroundColor: Colors.amber,
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
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
                'Total Uang Diterima: Rp $totalJumlah',
              ),
              pw.SizedBox(height: 10),

              // Tambahkan teks Total Pengeluaran
              pw.Text(
                'Total Uang Diberikan: Rp $totalJumlah1',
              ),
              pw.SizedBox(height: 10),

              // Tambahkan teks Untung
              pw.Text(
                'Sisa Utang: Rp  ${((totalJumlah - totalJumlah1).abs())}',
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
                },
                children: [
                  // Tambahkan header tabel
                  pw.TableRow(
                    children: [
                      pw.Text(' No',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(' Nama',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(' Rincian',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(' Terima',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                      pw.Text(' Berikan',
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ],
                  ),
                  for (int i = 0; i < savedSnapshot!.docs.length; i++)
                    pw.TableRow(
                      children: [
                        pw.Text((i + 1).toString()),
                        pw.Text(savedSnapshot!.docs[i]['Pelanggan'] ??
                            ''), // Kategori // No
                        pw.Text(
                            savedSnapshot!.docs[i]['role'] ?? ''), // Kategori
                        if (savedSnapshot!.docs[i]['role'] == 'Memberi')
                          pw.Text('Rp ${0}'), // Pemasukan
                        pw.Text(
                            'Rp ${savedSnapshot!.docs[i]['Jumlah'] ?? 0}'), // Pemasukan
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
