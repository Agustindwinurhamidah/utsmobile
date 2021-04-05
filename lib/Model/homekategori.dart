import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utsmobile/Model/entryformkategori.dart';
import 'package:utsmobile/Model/entryformstok.dart';
import 'package:utsmobile/Model/kategori.dart';
import 'package:utsmobile/dbhelper/dbhelper.dart';
import 'dart:async';
import 'stok.dart'; 
//pendukung program asinkron

class HomeKategori extends StatefulWidget {//membuat class kategori
  @override
  HomeKategoriState createState() => HomeKategoriState();
}

class HomeKategoriState extends State<HomeKategori> {
  DbHelper dbHelper = DbHelper();//manggil dbhelper
  int count = 0;
  List<Kategori> kategoriList;
  @override
  Widget build(BuildContext context) {
    updateListView();
    if (kategoriList == null) {
      kategoriList = List<Kategori>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Kategori Hijab'),//membuat tampilan bar yang bertuliskan daftar kategori hijab
      ),
    body:Column(children: [
      Expanded(
        child: createListView(),
      ),
      Container(
        alignment: Alignment.bottomCenter,
        child: SizedBox(
          width: double.infinity,
          child: RaisedButton(
            child: Text("Tambah Kategori"),//button unutk nambah kategori
            onPressed: () async {
              var kategori = await navigateToEntryForm(context, null);
              if (kategori != null) {
                //TODO 2 Panggil Fungsi untuk Insert ke DB
                int result = await dbHelper.insertKategori(kategori);
                if (result > 0) {
                  updateListView();
                }
                }
              },
            ),
          ),
        ),
      ]),
    );
  }
  Future<Kategori> navigateToEntryForm(BuildContext context, Kategori kategori) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryFormKategori(kategori);
    }));
    return result;
  }

  ListView createListView() {
    TextStyle textStyle = Theme.of(context).textTheme.headline5;
    return ListView.builder(
      itemCount: count,
      itemBuilder: (BuildContext context, int index) {
        return Card(
          color: Colors.white,
          elevation: 2.0,
          child: ListTile(
            leading: CircleAvatar(
              backgroundColor: Colors.red,
              child: Icon(Icons.ad_units),
            ),
            title: Text(
              this.kategoriList[index].namekategori,
              style: textStyle,
            ),

            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
                dbHelper.deleteKategori(this.kategoriList[index].id);
                updateListView();
                //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
              },
            ),
            onTap: () async {
              var kategori =
                  await navigateToEntryForm(context, this.kategoriList[index]);
              //TODO 4 Panggil Fungsi untuk Edit data
              int result = await dbHelper.updateKategori(kategori);
              if (result > 0) {
                updateListView();
              }
            },
          ),
        );
      },
    );
  }

  //update List item
  void updateListView() {
    final Future<Database> dbFuture = dbHelper.initDb();
    dbFuture.then((database) {
      //TODO 1 Select data dari DB
      Future<List<Kategori>> kategoriListFuture = dbHelper.getKategoriList();
      kategoriListFuture.then((kategoriList) {
        setState(() {
          this.kategoriList = kategoriList;
          this.count = kategoriList.length;
        });
      });
    });
  }
}


