import 'package:aplikasipembukuanumkm/ui/screens/Stok/addstok.dart';
import 'package:flutter/material.dart';

const List<String> list = <String>[
  'Semua',
  'Makanan',
  'Minuman',
  'Bahan Pokok'
];

class MainStok extends StatefulWidget {
  const MainStok({super.key});

  @override
  State<MainStok> createState() => _MainStokState();
}

class _MainStokState extends State<MainStok> {
  String dropdownValue = list.first;
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
                  onPressed: () {},
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
}
