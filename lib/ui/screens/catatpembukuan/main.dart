import 'package:aplikasipembukuanumkm/database/database.dart';
import 'package:aplikasipembukuanumkm/ui/screens/catatpembukuan/barangbuku.dart';
import 'package:aplikasipembukuanumkm/ui/screens/detail.dart';
import 'package:aplikasipembukuanumkm/ui/screens/mainhutang.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class CatatanPembukuan extends StatefulWidget {
  final Map<String, Map<String, dynamic>> selectedItemsDetails;
  const CatatanPembukuan({
    required this.selectedItemsDetails,
    Key? key,
  }) : super(key: key);

  @override
  State<CatatanPembukuan> createState() => _CatatanPembukuanState();
}

class _CatatanPembukuanState extends State<CatatanPembukuan> {
  Future<void> showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                SizedBox(height: 20),
                Container(
                    child: Icon(
                  Icons.verified,
                  color: Colors.green,
                  size: 64,
                )),
                SizedBox(height: 20),
                Center(
                    child: Text(
                  'Transaksi Berhasil',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                )),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  uploadData() async {
    // Ensure that the required fields are selected
    if (selectedOption == null || selectedBarang == null) {
      // Handle the case where required fields are not selected
      return;
    }

    int jumlahBelanja = int.parse(jumlahInputbarang.text);

    // Ensure that the stock is sufficient
    if (jumlahBelanja > currentStock && selectedOption == 'Pemasukan') {
      // Handle the case where the selected quantity exceeds the available stock
      // You can show an error message or take appropriate action
      return;
    }

    Map<String, dynamic> uploadData = {
      "role": selectedOption,
      "barang": selectedBarang,
      "jumlah_belanja": int.parse(jumlahInputbarang.text),
      "Total_pemasukan": int.parse(jumlahInput.text),
      "harga_modal": int.parse(hargamodal.text),
      "total_pengeluaran": int.parse(hargamodal.text)
    };

    // Update stock in Firestore
    await FirebaseFirestore.instance
        .collection('barang')
        .where('nama', isEqualTo: selectedBarang)
        .get()
        .then((querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        int updatedStock = currentStock;

        // Adjust stock based on the selected role (Pemasukan or Pengeluaran)
        if (selectedOption == 'Pemasukan') {
          updatedStock -= jumlahBelanja; // Reduce stock for Pemasukan
        } else if (selectedOption == 'Pengeluaran') {
          updatedStock += jumlahBelanja; // Increase stock for Pengeluaran
        }

        doc.reference.update({'stok_saatini': updatedStock});
      });
    });

    // Add data to the pembukuan collection
    await DatabaseMethods().addPembukuan(uploadData);
    showSuccessDialog();
  }

  String? selectedOption;
  String? selectedRole;
  TextEditingController dateInput = TextEditingController();
  TextEditingController PelanggganInput = TextEditingController();
  TextEditingController jumlahInput = TextEditingController();
  TextEditingController jumlahInputbarang = TextEditingController();
  TextEditingController hargamodal = TextEditingController();
  TextEditingController catatanInput = TextEditingController();
  String? selectedBarang;
  int currentStock = 0;
  String kategori = '';
  int hargajual = 0;
  int modal = 0;

  @override
  void initState() {
    // other code ...

    // Add a listener to the jumlahInputbarang text field
    jumlahInputbarang.addListener(() {
      updateFieldsBasedOnInput();
    });

    super.initState();
  }

  void updateFieldsBasedOnInput() {
    // Update the fields when jumlahInputbarang changes
    int newJumlahBelanja = int.tryParse(jumlahInputbarang.text) ?? 0;
    int newTotalPemasukan = newJumlahBelanja * hargajual;
    int newHargaModal = newJumlahBelanja * modal;

    // Update the text fields
    jumlahInput.text = newTotalPemasukan.toString();
    hargamodal.text = newHargaModal.toString();

    // Recalculate and update Keuntungan
    _calculateKeuntungan();
  }

  List<DropdownMenuItem<String>> getRoleItems() {
    final List<String> roles = selectedOption == 'Pemasukan'
        ? ['Penjualan', 'Penambahan Modal', 'Pendapatan Lain Lain']
        : selectedOption == 'Pengeluaran'
            ? ['Pembelian Stok', 'Pembayaran Utang', 'Pengeluaran Lain Lain']
            : [];

    return roles
        .map(
          (role) => DropdownMenuItem(
            key: ValueKey<String>('${role}_$selectedOption'),
            value: role,
            child: Text(role),
          ),
        )
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Column(
              children: [
                Text(
                  'Catat Pembukuan',
                  style: TextStyle(
                      fontSize: 16,
                      color: Colors.white,
                      fontWeight: FontWeight.w600),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.blue,
      ),
      body: SingleChildScrollView(
          child: Column(
        children: [
          SizedBox(height: 10),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Row(
              children: [
                Container(
                  width: 180,
                  child: ListTile(
                    title: const Text(
                      'Pemasukan',
                      style: TextStyle(fontSize: 12),
                    ),
                    leading: Radio(
                      value: 'Pemasukan',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                          selectedRole = null;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  width: 188,
                  child: ListTile(
                    title: const Text('Pengeluaran',
                        style: TextStyle(fontSize: 12)),
                    leading: Radio(
                      value: 'Pengeluaran',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                          selectedRole = null;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              width: double.infinity,
              child: DropdownButtonFormField<String>(
                value: selectedRole,
                hint: Text('Pilih Role'),
                items: getRoleItems(),
                onChanged: (value) {
                  setState(() {
                    selectedRole = value; // Keep only the latest selected value
                  });
                },
              ),
            ),
          ),
          SizedBox(height: 20),
          const Divider(
            thickness: 2,
            color: Colors.black,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Barang Terjual',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),

                // Dropdown to select the item
                FutureBuilder<List<String>>(
                  future:
                      fetchBarangList(), // Custom function to fetch the list of barang
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return Text('No items available.');
                    } else {
                      return DropdownButtonFormField<String>(
                        value: selectedBarang,
                        hint: Text('Pilih Barang'),
                        items: snapshot.data!
                            .map(
                              (barang) => DropdownMenuItem(
                                value: barang,
                                child: Text(barang),
                              ),
                            )
                            .toList(),
                        onChanged: (value) async {
                          setState(() {
                            selectedBarang = value;
                          });

                          // Fetch details for the selected item
                          var itemSnapshot = await FirebaseFirestore.instance
                              .collection('barang')
                              .where('nama', isEqualTo: value)
                              .get();

                          // Update currentStock and kategori
                          if (itemSnapshot.docs.isNotEmpty) {
                            var itemData = itemSnapshot.docs.first.data()
                                as Map<String, dynamic>;
                            currentStock = itemData['stok_saatini'];
                            kategori = itemData['kategori'];
                            hargajual = itemData['harga_jual'];
                            modal = itemData['harga_modal'];
                            jumlahInput.text = hargajual.toString();
                            hargamodal.text = modal.toString();
                          } else {
                            // Handle the case where the item is not found
                            currentStock = 0;
                            kategori = '';
                          }
                        },
                      );
                    }
                  },
                ),
                SizedBox(height: 10),
                // Display current stock and category
                Text('Stok Saat Ini: $currentStock'),
                Text('Kategori: $kategori'),

                // Input field for the quantity to buy
                Text('Jumlah yang ingin dibeli'),
                TextFormField(
                  controller: jumlahInputbarang,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(prefixText: 'Jumlah: '),
                ),
              ],
            ),
          ), // Divider line
          const Divider(
            thickness: 2,
            color: Colors.black,
          ), // Divider line
          // Input for total pemasukan, harga modal, dan keterangan keuntungan
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (selectedOption ==
                    'Pemasukan') // Show only if Pemasukan is selected
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Pemasukan'),
                      TextFormField(
                        controller: jumlahInput,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(prefixText: 'Rp '),
                        onChanged: (value) {
                          _calculateKeuntungan();
                        },
                      ),
                      SizedBox(height: 8),
                      Text('Harga Modal'),
                      TextFormField(
                        controller: hargamodal,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(prefixText: 'Rp '),
                        onChanged: (value) {
                          _calculateKeuntungan();
                        },
                      ),
                      SizedBox(height: 8),
                      Text(
                          'Keuntungan Rp ${_calculateKeuntungan().toString()}'),
                    ],
                  ),
                if (selectedOption ==
                    'Pengeluaran') // Show only if Pengeluaran is selected
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Total Pengeluaran'),
                      TextFormField(
                        controller: hargamodal,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(prefixText: 'Rp '),
                      ),
                    ],
                  ),
              ],
            ),
          ),

// ... (remaining code)

          // Button Simpan
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Handle saving data
                  uploadData();
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.amber),
                ),
                child: Text('Simpan'),
              ),
            ),
          ),
        ],
      )),
    );
  }

  double _calculateKeuntungan() {
    // Parse values from text fields
    double totalPemasukan = double.tryParse(jumlahInput.text) ?? 0;
    double hargaModal = double.tryParse(hargamodal.text) ?? 0;

    // Calculate Keuntungan
    double keuntungan = totalPemasukan - hargaModal;

    // Update the 'Keuntungan' text
    setState(() {
      catatanInput.text = 'Keuntungan Rp ${keuntungan.toString()}';
    });

    return keuntungan;
  }

  Future<List<String>> fetchBarangList() async {
    // Fetch the list of barang from Firestore
    var snapshot = await FirebaseFirestore.instance.collection('barang').get();

    // Extract the names of barang from the snapshot
    return snapshot.docs.map((doc) => doc['nama'] as String).toList();
  }
}
