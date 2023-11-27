import 'package:aplikasipembukuanumkm/database/database.dart';
import 'package:aplikasipembukuanumkm/ui/screens/detail.dart';
import 'package:aplikasipembukuanumkm/ui/screens/mainhutang.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class HutangPage extends StatefulWidget {
  const HutangPage({super.key});

  @override
  State<HutangPage> createState() => _HutangPageState();
}

class _HutangPageState extends State<HutangPage> {
  void _navigateToHutangDetail(BuildContext context, String tanggal,
      String pelanggan, int hutangDibayar, String role) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => MainHutang()
      ),
    );
  }

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
                _navigateToHutangDetail(
                  context,
                  dateInput.text,
                  PelanggganInput.text,
                  int.parse(jumlahInput.text),
                  selectedOption!
                );
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
      "Pelanggan": PelanggganInput.text,
      "Jumlah": int.parse(jumlahInput.text),
      "catatan": catatanInput.text,
      "Tanggal": dateInput.text,
      "role": selectedOption
    };

    await DatabaseMethods().addHutangDetails(uploadData);
    showSuccessDialog();
  }

  TextEditingController dateInput = TextEditingController();
  TextEditingController PelanggganInput = TextEditingController();
  TextEditingController jumlahInput = TextEditingController();
  TextEditingController catatanInput = TextEditingController();

  @override
  void initState() {
    dateInput.text = ""; //set the initial value of text field
    super.initState();
  }

  String? selectedOption;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Column(
          children: [
            Column(
              children: [
                Text(
                  'Catat Hutang',
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
                  width: 178,
                  child: ListTile(
                    title: const Text('Memberi'),
                    leading: Radio(
                      value: 'Memberi',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                  ),
                ),
                Container(
                  width: 175,
                  child: ListTile(
                    title: const Text('Terima'),
                    leading: Radio(
                      value: 'Menerima',
                      groupValue: selectedOption,
                      onChanged: (value) {
                        setState(() {
                          selectedOption = value;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Tujuan Ke'),
                SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: PelanggganInput,
                      decoration: InputDecoration(
                          hintText: 'Nama Pelangggan',
                          border: InputBorder.none,
                          icon: Icon(Icons.account_box_outlined)),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 25),
          Container(
            width: double.infinity,
            height: 5,
            color: Colors.blue,
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Jumlah'),
                SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: jumlahInput,
                      decoration: InputDecoration(
                          hintText: 'Rp 0',
                          border: InputBorder.none,
                          icon: Icon(Icons.monetization_on_outlined)),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 25),
          Container(
            width: double.infinity,
            height: 5,
            color: Colors.blue,
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 15),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Informasi Opsional'),
                SizedBox(height: 5),
                Container(
                  decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 10),
                    child: TextField(
                      controller: catatanInput,
                      decoration: InputDecoration(
                          hintText: 'Catatan',
                          border: InputBorder.none,
                          icon: Icon(Icons.note)),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(height: 15),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Input Tanggal'),
                  SizedBox(height: 5),
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.grey.shade300,
                        borderRadius: BorderRadius.circular(10)),
                    child: Padding(
                      padding: const EdgeInsets.only(left: 10),
                      child: TextField(
                        controller:
                            dateInput, //editing controller of this TextField
                        decoration: InputDecoration(
                          icon: Icon(Icons.calendar_today), //icon of text field
                          hintText: 'Masukkan Tanggal',
                          border: InputBorder.none, //label text of field
                        ),
                        readOnly:
                            true, //set it true, so that user will not able to edit text
                        onTap: () async {
                          DateTime? pickedDate = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime(
                                  2000), //DateTime.now() - not to allow to choose before today.
                              lastDate: DateTime(2101));

                          if (pickedDate != null) {
                            print(
                                pickedDate); //pickedDate output format => 2021-03-10 00:00:00.000
                            String formattedDate =
                                DateFormat('yyyy-MM-dd').format(pickedDate);
                            print(
                                formattedDate); //formatted date output using intl package =>  2021-03-16
                            //you can implement different kind of Date Format here according to your requirement

                            setState(() {
                              dateInput.text =
                                  formattedDate; //set output date to TextField value.
                            });
                          } else {
                            print("Date is not selected");
                          }
                        },
                      ),
                    ),
                  ),
                ],
              )),
          SizedBox(height: 15),
          SizedBox(
              width: double.infinity,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: ElevatedButton(
                  onPressed: () {
                    uploadData();
                  },
                  child: Text(
                    'Simpan',
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white),
                  ),
                  style: ButtonStyle(
                      backgroundColor: MaterialStatePropertyAll(Colors.amber)),
                ),
              )),
        ],
      )),
    );
  }
}
