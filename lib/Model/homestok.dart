import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utsmobile/Model/entryformstok.dart';
import 'package:utsmobile/Model/kategori.dart';
import 'package:utsmobile/dbhelper/dbhelper.dart';
import 'dart:async';
import 'entryformkategori.dart';
import 'stok.dart'; //pendukung program asinkron

class Home extends StatefulWidget {
  @override
  HomeState createState() => HomeState();
}

class HomeState extends State<Home> {
  DbHelper dbHelper = DbHelper();
  int count = 0;
  List<Item> itemList;
  @override
  Widget build(BuildContext context) {
    @override
  void initState() {
    super.initState();
    updateListView();
  }
    if (itemList == null) {
      itemList = List<Item>();
    }
    return Scaffold(
      appBar: AppBar(
        title: Text('Daftar Item'),
      ),
      body: Column(children: [
        Expanded(
          child: createListView(),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text("Tambah Item"),
              onPressed: () async {
                var item = await navigateToEntryForm(context, null);
                if (item != null) {
//TODO 2 Panggil Fungsi untuk Insert ke DB
                  int result = await dbHelper.insert(item);
                  if (result > 0) {
                    updateListView();
                  }
                }
              },
            ),
          ),
        ),
        Container(
          alignment: Alignment.bottomCenter,
          child: SizedBox(
            width: double.infinity,
            child: RaisedButton(
              child: Text("Tambah Kategori"),
              onPressed: () async {
                var kategori = await navigateToKategoriForm(context, null);
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

  Future<Item> navigateToEntryForm(BuildContext context, Item item) async {
    var result = await Navigator.push(context,
        MaterialPageRoute(builder: (BuildContext context) {
      return EntryForm(item);
    }));
    return result;
  }
  Future<Kategori> navigateToKategoriForm(BuildContext context, Kategori kategori) async {
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
              this.itemList[index].name,
              style: textStyle,
            ),
            subtitle: Text(this.itemList[index].price.toString()),
            trailing: GestureDetector(
              child: Icon(Icons.delete),
              onTap: () async {
//TODO 3 Panggil Fungsi untuk Delete dari DB berdasarkan Item
              dbHelper.delete(this.itemList[index].id);
              updateListView();
              },
            ),
            onTap: () async {
              var item =
                  await navigateToEntryForm(context, this.itemList[index]);
//TODO 4 Panggil Fungsi untuk Edit data
          if (item != null){
              dbHelper.update(item);
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
          Future<List<Item>> itemListFuture = dbHelper.getItemList();
          itemListFuture.then((itemList) {
            setState(() {
              this.itemList = itemList;
              this.count = itemList.length;
            });
          });
        });
      }
    }
    
   


