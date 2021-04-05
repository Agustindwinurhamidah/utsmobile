import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utsmobile/Model/entryformstok.dart';
import 'package:utsmobile/Model/kategori.dart';
import 'package:utsmobile/dbhelper/dbhelper.dart';
import 'dart:async';
import 'entryformkategori.dart';
import 'stok.dart'; //pendukung program asinkron

//pendukung program asinkron
class HomeStok extends StatefulWidget {//membuat class stok
  @override
  HomeStokState createState() => HomeStokState();
}

class HomeStokState extends State<HomeStok> {
  DbHelper dbHelper = DbHelper();//memanggil dbhelper 
  int count = 0;
  List<Stok> stokList;
  @override
  Widget build(BuildContext context) {
    updateListView();
    if (stokList == null) {
      stokList = List<Stok>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Stok Hijab'),//membuat bar yang bertulis daftar stok hijab
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
            child: Text("Tambah Stok"),//membuat button untuk nambah data stok yang bertuliskan tambah stok
            onPressed: () async {
              var stok = await navigateToEntryForm(context, null);
              if (stok != null) {
                //TODO 2 Panggil Fungsi untuk Insert ke DB
                int result = await dbHelper.insertStok(stok);
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

  Future<Stok> navigateToEntryForm(BuildContext context, Stok stok) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(stok);
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
              this.stokList[index].name,
              style: textStyle,
            ),
            subtitle: Text('Stok='+ this.stokList[index].stok.toString()),

            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
                dbHelper.deleteStok(this.stokList[index].id);
                updateListView();
                //TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
              },
            ),
            onTap: () async {
              var Stok =
                  await navigateToEntryForm(context, this.stokList[index]);
              //TODO 4 Panggil Fungsi untuk Edit data
              int result = await dbHelper.updatestok(Stok);
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
      Future<List<Stok>> stokListFuture = dbHelper.getstokList();
      stokListFuture.then((stokList) {
        setState(() {
          this.stokList = stokList;
          this.count = stokList.length;
        });
      });
    });
  }
}


