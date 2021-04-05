import 'package:flutter/material.dart';
import 'kategori.dart';

class EntryFormKategori extends StatefulWidget {
  final Kategori kategori;
  EntryFormKategori(this.kategori);
  @override
  EntryFormState createState() => EntryFormState(this.kategori);
}

//class controller
class EntryFormState extends State<EntryFormKategori> {
  Kategori kategori;
  EntryFormState(this.kategori);
  TextEditingController namekategoriController = TextEditingController();

 

  
  @override
  Widget build(BuildContext context) {
//kondisi
    if (kategori != null) {
      namekategoriController.text = kategori.namekategori; 
      
    }
//rubah
    return Scaffold(
        appBar: AppBar(
          title: kategori == null ? Text('Tambah') : Text('Ubah'),
          leading: Icon(Icons.keyboard_arrow_left),
        ),
        body: Padding(
          padding: EdgeInsets.only(top: 15.0, left: 10.0, right: 10.0),
          child: ListView(
            children: <Widget>[
// nama
               Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: TextField(
                  controller: namekategoriController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    labelText: 'Nama Kategori',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(5.0),
                    ),
                  ),
                  onChanged: (value) {
//
                  },
                ),
              ),
             
               
             
// tombol button
              Padding(
                padding: EdgeInsets.only(top: 20.0, bottom: 20.0),
                child: Row(
                  children: <Widget>[
// tombol simpan
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Save',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          if (kategori == null) {
// tambah data
                            kategori = Kategori(
                                namekategoriController.text,
                                );
                                
                          } else {
// ubah data
                            kategori.namekategori = namekategoriController.text;
                           
                           
                            
                          }
// kembali ke layar sebelumnya dengan membawa objek item
                          Navigator.pop(context, kategori);
                        },
                      ),
                    ),
                    Container(
                      width: 5.0,
                    ),
// tombol batal
                    Expanded(
                      child: RaisedButton(
                        color: Theme.of(context).primaryColorDark,
                        textColor: Theme.of(context).primaryColorLight,
                        child: Text(
                          'Cancel',
                          textScaleFactor: 1.5,
                        ),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ));
  }
}
