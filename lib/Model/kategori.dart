
class Kategori {
  int _id;
  String _namekategori;
 

  int get id => _id;
  String get namekategori => this._namekategori;
  set namekategori(String value) => this._namekategori = value;
   
// konstruktor versi 1
  Kategori(this._namekategori);
// konstruktor versi 2: konversi dari Map ke Item
  Kategori.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._namekategori = map['namekategori'];
     
  }
// konversi dari Item ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['namekategori'] = _namekategori; 
    return map;
  }
}
