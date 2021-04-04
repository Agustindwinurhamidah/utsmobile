import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:utsmobile/Model/homestok.dart';
import 'package:utsmobile/Model/kategori.dart';
import 'package:utsmobile/Model/stok.dart';
import 'dart:async';
import 'dart:io';

class DbHelper {
  static DbHelper _dbHelper;
  static Database _database;
  DbHelper._createObject();
  Future<Database> initDb() async {
//untuk menentukan nama database dan lokasi yg dibuat
    Directory directory = await getApplicationDocumentsDirectory();
    String path = directory.path + 'item.db';
//create, read databases
    var itemDatabase = openDatabase(path, version: 4, onCreate: _createDb);
//mengembalikan nilai object sebagai hasil dari fungsinya
    return itemDatabase;
  }

//buat tabel baru dengan nama item
  void _createDb(Database db, int version) async {
    await db.execute('''
    CREATE TABLE stok (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      price INTEGER,
      stok INTEGER
      )
      ''');
      await db.execute('''
      CREATE TABLE kategori (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        namekategori TEXT
        )
        ''');
        }

//select databases
  Future<List<Map<String, dynamic>>> select() async {
    Database db = await this.initDb();
    var mapList = await db.query('item', orderBy: 'name');
    return mapList;
  }
  Future<List<Map<String, dynamic>>> selectKategori() async {
    Database db = await this.initDb();
    var mapList = await db.query('kategori', orderBy: 'name');
    return mapList;
  }

//create databases
  Future<int> insert(Item object) async {
    Database db = await this.initDb();
    int count = await db.insert('item', object.toMap());
    return count;
  }
   Future<int> insertKategori(Kategori object) async {
    Database db = await this.initDb();
    int count = await db.insert('kategori', object.toMap());
    return count;
  }

//update databases
  Future<int> update(Item object) async {
    Database db = await this.initDb();
    int count = await db.update('item', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }
  Future<int> updateKategori(Kategori object) async {
    Database db = await this.initDb();
    int count = await db.update('kategori', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

//delete databases
 
  Future<int> delete(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('item', where: 'id=?', whereArgs: [id]);
    return count;
  }
   Future<int> deleteKategori(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('kategori', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Item>> getItemList() async {
    var itemMapList = await select();
    int count = itemMapList.length;
    List<Item> itemList = List<Item>();
    for (int i = 0; i < count; i++) {
      itemList.add(Item.fromMap(itemMapList[i]));
    }
    return itemList;
  }
   Future<List<Kategori>> getKategoriList() async {
    var kategoriMapList = await select();
    int count = kategoriMapList.length;
    List<Kategori> kategoriList = List<Kategori>();
    for (int i = 0; i < count; i++) {
      kategoriList.add(Kategori.fromMap(kategoriMapList[i]));
    }
    return kategoriList;
  }

  factory DbHelper() {
    if (_dbHelper == null) {
      _dbHelper = DbHelper._createObject();
    }
    return _dbHelper;
  }
  Future<Database> get database async {
    if (_database == null) {
      _database = await initDb();
    }
    return _database;
  }
}