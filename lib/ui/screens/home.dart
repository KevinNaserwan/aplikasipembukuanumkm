import 'package:aplikasipembukuanumkm/ui/screens/Stok/mainstok.dart';
import 'package:aplikasipembukuanumkm/ui/screens/catathutang.dart';
import 'package:aplikasipembukuanumkm/ui/screens/mainhutang.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: ElevatedButton.icon(
          onPressed: () {},
          icon: Icon(
            Icons.menu,
            color: Colors.white,
          ),
          label: Text(
            'Lainnya',
            style: TextStyle(color: Colors.white),
          ),
          style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(Colors.transparent),
              elevation: MaterialStatePropertyAll(0)),
        ),
        backgroundColor: Colors.blue,
      ),
      body: Column(
        children: [
          SizedBox(height: 20),
          Padding(
              padding: EdgeInsets.symmetric(horizontal: 15),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.blue.shade300,
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: Colors.black, width: 2)),
                child: Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Icon(Icons.wallet, size: 40, color: Colors.amber),
                          SizedBox(width: 30),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Selamat Datang!',
                                style: TextStyle(
                                    fontWeight: FontWeight.w600, fontSize: 16),
                              ),
                              Text('Owner Warung Sembako')
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5),
            child: Column(
              children: [
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStatePropertyAll(
                                  Colors.grey.shade400),
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.grey.shade200),
                              elevation: MaterialStatePropertyAll(0),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(200)))),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MainHutang()));
                          },
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  'Hutang',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                SizedBox(height: 15),
                                Image.asset(
                                  'assets/books.png',
                                  width: 70,
                                ),
                                SizedBox(height: 20)
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStatePropertyAll(
                                  Colors.grey.shade400),
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.grey.shade200),
                              elevation: MaterialStatePropertyAll(0),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(200)))),
                          onPressed: () {},
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                Text(
                                  'Catat',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                SizedBox(height: 5),
                                Image.asset(
                                  'assets/pembukuan.png',
                                  width: 70,
                                ),
                                Text(
                                  'Pembukuan',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                SizedBox(height: 20)
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStatePropertyAll(
                                  Colors.grey.shade400),
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.grey.shade200),
                              elevation: MaterialStatePropertyAll(0),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(200)))),
                          onPressed: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => MainStok()));
                          },
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(height: 30),
                                Image.asset(
                                  'assets/stok.png',
                                  width: 70,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Stok',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                SizedBox(height: 20)
                              ],
                            ),
                          )),
                    ),
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStatePropertyAll(
                                  Colors.grey.shade400),
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.grey.shade200),
                              elevation: MaterialStatePropertyAll(0),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(200)))),
                          onPressed: () {},
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                Image.asset(
                                  'assets/growth.png',
                                  width: 70,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'Laporan Usaha',
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                SizedBox(height: 20)
                              ],
                            ),
                          )),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 160,
                      height: 160,
                      child: ElevatedButton(
                          style: ButtonStyle(
                              overlayColor: MaterialStatePropertyAll(
                                  Colors.grey.shade400),
                              backgroundColor: MaterialStatePropertyAll(
                                  Colors.grey.shade200),
                              elevation: MaterialStatePropertyAll(0),
                              shape: MaterialStatePropertyAll(
                                  RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(200)))),
                          onPressed: () {},
                          child: Container(
                            child: Column(
                              children: [
                                SizedBox(height: 20),
                                Image.asset(
                                  'assets/money.png',
                                  width: 70,
                                ),
                                SizedBox(height: 5),
                                Text(
                                  'Laporan Keuangan',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: 14, color: Colors.black),
                                ),
                                SizedBox(height: 20)
                              ],
                            ),
                          )),
                    ),
                  ],
                )
              ],
            ),
          )
        ],
      ),
    );
  }
}
