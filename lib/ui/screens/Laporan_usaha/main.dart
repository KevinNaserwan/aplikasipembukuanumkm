import 'package:aplikasipembukuanumkm/ui/screens/Laporan_usaha/detailutang.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class MainLU extends StatefulWidget {
  const MainLU({super.key});

  @override
  State<MainLU> createState() => _MainLUState();
}

class _MainLUState extends State<MainLU> {
  String selectedOption = 'Pemasukan';
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      initialDatePickerMode: DatePickerMode.year,
    );

    if (picked != null && picked != selectedDate) {
      setState(() {
        // Set the selected date to the first day of the chosen month
        selectedDate = DateTime(picked.year, picked.month, 1);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = DateFormat.yMMMM().format(selectedDate);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Laporan Usaha',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                  color: Colors.white),
            ),
            GestureDetector(
              onTap: () => _selectDate(context),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  IconButton(
                      icon: Icon(Icons.calendar_today),
                      color: Colors.white,
                      onPressed: () {}),
                  Text(
                    formattedDate,
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              children: [
                BoxWithExpansionTile(
                  title: 'Transaksi Pembukuan',
                  content: 'Informasi tentang Transaksi Pembukuan',
                  selectedDate: selectedDate,
                ),
                BoxWithExpansionTileStok(
                  title: 'Pengelolaan Stok',
                  content: 'Informasi tentang Pengelolaan Stok',
                ),
                BoxWithExpansionTileUtang(selectedDate: selectedDate),
                // ... (other BoxWithExpansionTile instances)
              ],
            ),
          )
        ],
      ),
    );
  }
}

class BoxWithExpansionTile extends StatefulWidget {
  final String title;
  final String content;
  final DateTime selectedDate;

  const BoxWithExpansionTile({
    required this.title,
    required this.content,
    required this.selectedDate,
    Key? key,
  }) : super(key: key);

  @override
  _BoxWithExpansionTileState createState() => _BoxWithExpansionTileState();
}

class _BoxWithExpansionTileState extends State<BoxWithExpansionTile> {
  bool isExpanded = false;
  String selectedOption = 'Pemasukan'; // Default selection

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('pembukuan')
            // .where('Tanggal',
            //     isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(
            //         widget.selectedDate.year, widget.selectedDate.month)))
            // .where('Tanggal',
            //     isLessThan: Timestamp.fromDate(DateTime(
            //         widget.selectedDate.year, widget.selectedDate.month + 1)))
            .snapshots(),
        builder: (context, snapshot) {
          // Calculate the sum of 'jumlah' field
          List<DocumentSnapshot> filteredDocuments = [];
          if (snapshot.hasData) {
            if (selectedOption == 'Pemasukan') {
              filteredDocuments = snapshot.data!.docs
                  .where((doc) => doc['role'] == 'Pemasukan')
                  .toList();
            } else if (selectedOption == 'Pengeluaran') {
              filteredDocuments = snapshot.data!.docs
                  .where((doc) => doc['role'] == 'Pengeluaran')
                  .toList();
            }
          }

          // Calculate the sum of 'jumlah' field
          int numberOfDocuments = filteredDocuments.length;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: ExpansionTile(
                title: Text(widget.title),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedOption = 'Pemasukan';
                          });
                        },
                        child: Text(
                          'Pemasukan',
                          style: TextStyle(
                            color: selectedOption == 'Pemasukan'
                                ? Colors.blue // Selected color
                                : Colors.black,
                          ),
                        ),
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            selectedOption = 'Pengeluaran';
                          });
                        },
                        child: Text(
                          'Pengeluaran',
                          style: TextStyle(
                            color: selectedOption == 'Pengeluaran'
                                ? Colors.blue // Selected color
                                : Colors.black,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 30),
                  if (selectedOption == 'Pemasukan')
                    Container(
                      width: 200,
                      child: Text(
                        '$numberOfDocuments Pemasukan Tercatat Bulan Ini',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ), // Replace with actual data
                  if (selectedOption == 'Pengeluaran')
                    Container(
                      width: 200,
                      child: Text(
                        '$numberOfDocuments Pengeluaran Tercatat Bulan Ini',
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  SizedBox(height: 60), // Replace w// Replace with actual data
                ],
                onExpansionChanged: (value) {
                  setState(() {
                    isExpanded = value;
                  });
                },
              ),
            ),
          );
        });
  }
}

class BoxWithExpansionTileStok extends StatefulWidget {
  final String title;
  final String content;

  const BoxWithExpansionTileStok({
    required this.title,
    required this.content,
    Key? key,
  }) : super(key: key);

  @override
  _BoxWithExpansionTileStokState createState() =>
      _BoxWithExpansionTileStokState();
}

class _BoxWithExpansionTileStokState extends State<BoxWithExpansionTileStok> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Card(
        child: ExpansionTile(
          title: Text(widget.title),
          children: [
            // Box 1: Product and Category with highest sales
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('pembukuan')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return Text('No data available.');
                  } else {
                    // Sort the documents based on the 'jumlah_belanja' field in descending order
                    var sortedDocs = snapshot.data!.docs
                      ..sort((a, b) =>
                          b['jumlah_belanja'].compareTo(a['jumlah_belanja']));

                    // Get the most popular product (first document after sorting)
                    var mostPopularProduct = sortedDocs.isNotEmpty
                        ? sortedDocs.first['barang'] as String
                        : 'No product';

                    // Calculate total penjualan and total modal
                    var totalPenjualan = sortedDocs.fold(
                        0, (sum, doc) => sum + (doc['Total_pemasukan'] as int));
                    var totalModal = sortedDocs.fold(
                        0, (sum, doc) => sum + (doc['harga_modal'] as int));
                    var keuntungan = totalPenjualan - totalModal;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Produk Paling Laris'),
                        Text('Nama Produk: $mostPopularProduct'),
                        Divider(),
                        // Box 2: Transaction Details
                        Container(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Total Transaksi dengan Produk'),
                              Text('(Total Penjualan - Total Modal)'),
                              Divider(),
                              Text(
                                  'Total Penjualan: \$$totalPenjualan'), // Replace with actual total sales
                              Text(
                                  'Total Modal: \$$totalModal'), // Replace with actual total cost
                              Text(
                                  'Keuntungan: \$$keuntungan'), // Replace with actual profit // Replace with actual total sales
                            ],
                          ),
                        ),
                      ],
                    );
                  }
                },
              ),
            ),
          ],
          onExpansionChanged: (value) {
            setState(() {
              isExpanded = value;
            });
          },
        ),
      ),
    );
  }
}

class BoxWithExpansionTileUtang extends StatefulWidget {
  final DateTime selectedDate;
  const BoxWithExpansionTileUtang({
    Key? key,
    required this.selectedDate,
  }) : super(key: key);

  @override
  _BoxWithExpansionTileUtangState createState() =>
      _BoxWithExpansionTileUtangState();
}

class _BoxWithExpansionTileUtangState extends State<BoxWithExpansionTileUtang> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('catatan_hutang')
            .where('Tanggal',
                isGreaterThanOrEqualTo: Timestamp.fromDate(DateTime(
                    widget.selectedDate.year, widget.selectedDate.month)))
            .where('Tanggal',
                isLessThan: Timestamp.fromDate(DateTime(
                    widget.selectedDate.year, widget.selectedDate.month + 1)))
            .snapshots(),
        builder: (context, snapshot) {
          // Calculate the sum of 'jumlah' field
          double totalJumlah = 0;
          if (snapshot.hasData) {
            final documents = snapshot.data!.docs;
            for (var document in documents) {
              // Check if the role is 'Memberi' before adding to totalJumlah
              if (document['role'] == 'Memberi') {
                totalJumlah += document['Jumlah'];
              }
            }
          }
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Card(
              child: ExpansionTile(
                title: Text('Utang'),
                children: [
                  // Utang Saya
                  Container(
                    padding: EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Utang Saya'),
                        Divider(), // Divider line
                        Text('Rp $totalJumlah'), // Replace with actual amount
                      ],
                    ),
                  ),

                  // Utang Pelanggan
                  StreamBuilder<QuerySnapshot>(
                      stream: FirebaseFirestore.instance
                          .collection('catatan_hutang')
                          .where('Tanggal',
                              isGreaterThanOrEqualTo: Timestamp.fromDate(
                                  DateTime(widget.selectedDate.year,
                                      widget.selectedDate.month)))
                          .where('Tanggal',
                              isLessThan: Timestamp.fromDate(DateTime(
                                  widget.selectedDate.year,
                                  widget.selectedDate.month + 1)))
                          .snapshots(),
                      builder: (context, snapshot) {
                        // Calculate the sum of 'jumlah' field
                        double totalJumlah = 0;
                        if (snapshot.hasData) {
                          final documents = snapshot.data!.docs;
                          for (var document in documents) {
                            // Check if the role is 'Memberi' before adding to totalJumlah
                            if (document['role'] == 'Menerima') {
                              totalJumlah += document['Jumlah'];
                            }
                          }
                        }
                        return Container(
                          padding: EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('Utang Pelanggan'),
                              Divider(), // Divider line
                              Text(
                                  'Rp $totalJumlah'), // Replace with actual amount
                            ],
                          ),
                        );
                      }),

                  // Lihat Laporan Utang Button
                  Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => DetailUtang(),
                                      maintainState: false));
                              // Handle button press action
                              // You can navigate to the Utang report screen or perform any other action
                            },
                            style: ElevatedButton.styleFrom(
                              primary:
                                  Colors.amber, // Set button color to amber
                            ),
                            child: Text('Lihat Laporan Utang'),
                          ),
                        ),
                      ),
                      SizedBox(height: 30)
                    ],
                  ),
                ],
                onExpansionChanged: (value) {
                  setState(() {
                    isExpanded = value;
                  });
                },
              ),
            ),
          );
        });
  }
}
