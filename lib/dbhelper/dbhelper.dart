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
    String path = directory.path + 'stok.db';

    //create, read databases
    var itemDatabase = openDatabase(path, version: 6, onCreate: _createDb, onUpgrade: _onUpgrade);
    //mengembalikan nilai object sebagai hasil dari fungsinya
    return itemDatabase;
  }

  //update tabel
  void _onUpgrade(Database db, int oldVersion, int newVersion) async {
    _createDb(db, newVersion);
  }

  //buat tabel baru dengan nama item
  void _createDb(Database db, int version) async {
    var batch = db.batch();
    batch.execute('DROP TABLE IF EXISTS stok');
    batch.execute('DROP TABLE IF EXISTS kategori');
    batch.execute('''
      CREATE TABLE stok (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      name TEXT,
      price INTEGER,
      stok INTEGER
      )
    ''');
    batch.execute('''
      CREATE TABLE kategori (
      id INTEGER PRIMARY KEY AUTOINCREMENT,
      namekategori TEXT
      
      )
    ''');
    await batch.commit();
  }

//select databases
  Future<List<Map<String, dynamic>>> selectStok() async {
    Database db = await this.initDb();
    var mapList = await db.query(
      'stok',
      orderBy: 'id DESC',
      limit: 3,
    ); //menampilkan data dari table diurutkan dengan nama
    return mapList;
  }

  Future<List<Map<String, dynamic>>> selectKategori() async {
    Database db = await this.initDb();
    var mapList = await db.query(
      'kategori',
      orderBy: 'id DESC',
      limit: 3,
    ); //menampilkan data dari table diurutkan dengan nama
    return mapList;
  }

//create databases
  Future<int> insertStok(Stok object) async {
    Database db = await this.initDb();
    int count = await db.insert('stok', object.toMap());
    return count;
  }

  Future<int> insertKategori(Kategori object) async {
    Database db = await this.initDb();
    int count = await db.insert('kategori', object.toMap());
    return count;
  }

//update databases
  Future<int> updatestok(Stok object) async {
    Database db = await this.initDb();
    int count = await db.update('stok', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  Future<int> updateKategori(Kategori object) async {
    Database db = await this.initDb();
    int count = await db.update('kategori', object.toMap(), where: 'id=?', whereArgs: [object.id]);
    return count;
  }

  //delete databases
  Future<int> deleteStok(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('stok', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<int> deleteKategori(int id) async {
    Database db = await this.initDb();
    int count = await db.delete('kategori', where: 'id=?', whereArgs: [id]);
    return count;
  }

  Future<List<Stok>> getstokList() async {
    var stokMapList = await selectStok();
    int count = stokMapList.length;
    List<Stok> stokList = [];
    for (int i = 0; i < count; i++) {
      stokList.add(Stok.fromMap(stokMapList[i]));
    }
    return stokList;
  }

  Future<List<Kategori>> getKategoriList() async {
    var kategoriMapList = await selectKategori();
    int count = kategoriMapList.length;
    List<Kategori> kategoriList = [];
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
