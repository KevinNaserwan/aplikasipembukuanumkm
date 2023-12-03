import 'package:aplikasipembukuanumkm/ui/screens/mainhutang.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class HutangDetail extends StatefulWidget {
  final String formattedDate;
  final String pelanggan;
  final int hutangDibayar;
  final String role;

  const HutangDetail(
      {Key? key,
      required this.formattedDate,
      required this.pelanggan,
      required this.hutangDibayar,
      required this.role})
      : super(key: key);

  @override
  State<HutangDetail> createState() => _HutangDetailState();
}

class _HutangDetailState extends State<HutangDetail> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Detail Transaksi',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.w600, color: Colors.white),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Container(
              decoration: BoxDecoration(color: Colors.blue.shade300),
              child: Padding(
                padding: const EdgeInsets.all(25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Tanggal'), Text(widget.formattedDate)],
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [Text('Pelanggan'), Text(widget.pelanggan)],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 2,
                      decoration: BoxDecoration(color: Colors.black),
                    ),
                    SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(widget.role == 'Memberi'
                            ? 'Berhutang Sebanyak'
                            : 'Hutang Dibayar'),
                        Text('Rp ${widget.hutangDibayar.toString()}')
                      ],
                    ),
                    SizedBox(height: 10),
                    Container(
                      width: double.infinity,
                      height: 2,
                      decoration: BoxDecoration(color: Colors.black),
                    ),
                    ElevatedButton(
                        style: ButtonStyle(
                            elevation: MaterialStatePropertyAll(0),
                            backgroundColor:
                                MaterialStatePropertyAll(Colors.transparent)),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text(''))
                  ],
                ),
              ),
            ),
          )
        ],
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      floatingActionButton: FloatingActionButton.extended(
          backgroundColor: Colors.red,
          onPressed: () async {
            // Get the reference to the Firestore collection
            final collectionReference =
                FirebaseFirestore.instance.collection('catatan_hutang');

            try {
              // Find the document with a specific condition (you need to adjust this based on your data model)
              var querySnapshot = await collectionReference
                  .where('Pelanggan', isEqualTo: widget.pelanggan)
                  .where('Jumlah', isEqualTo: widget.hutangDibayar)
                  .where('role', isEqualTo: widget.role)
                  .get();

              // If there is a matching document, delete it
              if (querySnapshot.docs.isNotEmpty) {
                await collectionReference
                    .doc(querySnapshot.docs[0].id)
                    .delete();

                // Navigate back to the MainHutang screen after deletion
                Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => MainHutang()));
              } else {
                // Handle the case when no matching document is found
                print('No matching document found');
              }
            } catch (e) {
              print('Error deleting document: $e');
              // Handle the error as needed
            }
          },
          label: Row(
            children: [Icon(Icons.delete), Text('Hapus Transaksi')],
          )),
    );
  }
}
