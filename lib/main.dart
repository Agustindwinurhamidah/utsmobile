import 'package:flutter/material.dart';
import 'package:utsmobile/Model/homestok.dart';
import 'package:utsmobile/Model/homestok.dart';
import 'package:utsmobile/Model/homekategori.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.red,
      ),
      home: DefaultTabController(
        length: 2,
        child: Scaffold(
            appBar: AppBar(
              title: Text("Toko Hijab Agustin Dwi"),//judul pada bar awal
              bottom: TabBar(
                tabs: [
                  Tab(
                    text: "Stok",//bar stok
                  ),
                  Tab(
                    text: "Kategori",//bar kategori
                  ),
                ],
              ),
            ),
            body: TabBarView(//2 tabel
              children: [
                HomeStok(),//memanggil class stok
                HomeKategori(),//memanggil class kategori
              ],
            )),
      ),
    );
  }
}