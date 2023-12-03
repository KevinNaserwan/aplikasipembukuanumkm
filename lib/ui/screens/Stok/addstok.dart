import 'package:flutter/material.dart';
import 'package:aplikasipembukuanumkm/database/database.dart';

const List<String> list = <String>[
  'Botol',
  'Bungkus',
  'Dus',
  'Karung',
  'Kaleng',
  'Kg',
  'Pcs',
  'Lembar',
  'Liter',
  'Pasang'
];

class AddStock extends StatefulWidget {
  const AddStock({super.key});

  @override
  State<AddStock> createState() => _AddStockState();
}

class _AddStockState extends State<AddStock> {
  Future<void> showSuccessDialog() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Barang berhasil ditambahkan'),
          content: Text('Barang baru telah berhasil ditambahkan.'),
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
    Map<String, dynamic> uploadData = {
      "nama": namabarang.text,
      "harga_jual": int.parse(harga_jual.text),
      "harga_modal": int.parse(harga_modal.text),
      "stok_saatini": int.parse(stoksaatini.text),
      "stok_minimum": int.parse(stok_minimum.text),
      "kategori": dropdownValue
    };

    await DatabaseMethods().addbarang(uploadData);
    showSuccessDialog();
  }

  String dropdownValue = list.first;
  TextEditingController namabarang = TextEditingController();
  TextEditingController harga_jual = TextEditingController();
  TextEditingController harga_modal = TextEditingController();
  TextEditingController stok_minimum = TextEditingController();
  TextEditingController stoksaatini = TextEditingController();
  TextEditingController kategori = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text(
          'Tambah Barang Baru',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('Kategori Barang'),
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: namabarang,
                        decoration: InputDecoration(
                          hintText: 'Nama Barang',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('Harga Jual'),
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: harga_jual,
                        decoration: InputDecoration(
                          hintText: 'Harga Jual',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.only(left: 8),
                    child: Text('Harga Modal'),
                  ),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: TextField(
                        controller: harga_modal,
                        decoration: InputDecoration(
                          hintText: 'Harga Modal',
                          border: InputBorder.none,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
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
                  SizedBox(height: 25),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Kelola Stok'),
                      SizedBox(height: 10),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10)),
                            child: SizedBox(
                              width: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextField(
                                  controller: stoksaatini,
                                  decoration: InputDecoration(
                                      hintText: 'Stok Saat Ini',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                                color: Colors.grey.shade300,
                                borderRadius: BorderRadius.circular(10)),
                            child: SizedBox(
                              width: 150,
                              child: Padding(
                                padding: const EdgeInsets.only(left: 20),
                                child: TextField(
                                  controller: stok_minimum,
                                  decoration: InputDecoration(
                                      hintText: 'Stok Minimum',
                                      border: InputBorder.none),
                                ),
                              ),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                  SizedBox(height: 30),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.amber),
                          overlayColor:
                              MaterialStatePropertyAll(Colors.amber.shade300)),
                      onPressed: () {
                        uploadData();
                      },
                      child: SizedBox(
                          width: double.infinity,
                          child: Center(
                              child: Text(
                            'Simpan',
                            style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.white),
                          ))))
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
