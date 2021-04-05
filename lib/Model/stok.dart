
class Stok {
  int _id;
  String _name;
  int _price;
  int _stok;

  int get id => _id;
  String get name => this._name;
  set name(String value) => this._name = value;
  get price => this._price;
  set price(value) => this._price = value;
  get stok => this._stok;
  set stok(value) => this._stok = value;
  
// konstruktor versi 1
  Stok(this._name, this._price, this._stok);
// konstruktor versi 2: konversi dari Map ke Item
  Stok.fromMap(Map<String, dynamic> map) {
    this._id = map['id'];
    this._name = map['name'];
    this._price = map['price'];
    this._stok = map['stok'];
   
  }
// konversi dari Item ke Map
  Map<String, dynamic> toMap() {
    Map<String, dynamic> map = Map<String, dynamic>();
    map['id'] = this._id;
    map['name'] = _name;
    map['price'] = _price;
    map['stok'] = _stok;
   
    return map;
  }
}
