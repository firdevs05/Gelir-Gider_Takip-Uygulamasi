import 'package:flutter/material.dart';
import 'islem_model.dart';
import 'veritabani_islemleri.dart';

class ekle extends StatefulWidget {
  ekle({super.key});

  @override
  State<ekle> createState() => _ekleState();
}

class _ekleState extends State<ekle> {
  String? _tur, _kategori;
  DateTime? _secilenTarihNesnesi; //veritabanına kaydetmek için

  TextEditingController _tarihcontroller = TextEditingController(); //ekrana yazdırmak için
  TextEditingController _tutarcontroller = TextEditingController();
  TextEditingController _aciklamacontroller = TextEditingController();

  @override
  void dispose() {
    //sayfa kapanınca controller'ları bellekten temizle
    _tarihcontroller.dispose();
    _tutarcontroller.dispose();
    _aciklamacontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double ekranGenisligi = MediaQuery.of(context).size.width;
    double ekranYuksekligi = MediaQuery.of(context).size.height;

    List<String> gelirListesi=["Maaş","Burs","Ek İş","Harçlık","Diğer"];
    List<String> giderListesi=["Ulaşım","Kıyafet","Yemek","Fatura","Market Alışverişi","Diğer"];
    List<String> gosterilecekListe;
    gosterilecekListe= _tur=="Gelir" ? gelirListesi : giderListesi;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(20),
          child: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Tür (*)",
                  border: OutlineInputBorder(), //siyah çerçeve
                ),
                value: _tur, //şu an seçili olan değer
                items: const [
                  DropdownMenuItem(value: "Gelir", child: Text("Gelir")),
                  DropdownMenuItem(value: "Gider", child: Text("Gider")),
                ],
                onChanged: (yeniDeger) {
                  setState(() {
                    _tur = yeniDeger;
                    _kategori=null;
                  });
                },
              ),
              const SizedBox(height: 20),

              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Kategori (*)",
                  border: OutlineInputBorder(),
                ),
                value: _kategori,
                items: gosterilecekListe.map((String kategoriAdi) {
                  return DropdownMenuItem(
                    value: kategoriAdi,
                    child: Text(kategoriAdi),
                  );
                }).toList(),

                onChanged: (yeniDeger) {
                  setState(() {
                    _kategori = yeniDeger;
                  });
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _tarihcontroller,
                readOnly: true, //elle yazmayı engelle
                decoration: const InputDecoration(
                  labelText: "Tarih (*)",
                  border: OutlineInputBorder(),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 15,
                    vertical: 15,
                  ),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                onTap: () async {
                  DateTime? secilenTarih = await showDatePicker(
                    context: context,
                    initialDate: DateTime.now(),
                    firstDate: DateTime(2020),
                    lastDate: DateTime(2030),
                  );

                  if (secilenTarih != null) {
                    setState(() {
                      _tarihcontroller.text =
                          "${secilenTarih.day}/${secilenTarih.month}/${secilenTarih.year}";
                      _secilenTarihNesnesi=secilenTarih;
                    });
                  }
                },
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _tutarcontroller,
                keyboardType:
                    TextInputType.number, //sadece sayı klavyesi açılsın
                decoration: const InputDecoration(
                  labelText: "Tutar (*)",
                  hintText: "Örn: 100",
                  border:
                      UnderlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),

              TextFormField(
                controller: _aciklamacontroller,
                decoration: const InputDecoration(
                  labelText: "Açıklama (isteğe bağlı)",
                  border:
                      UnderlineInputBorder(),
                ),
              ),
              SizedBox(height: 200),

              SizedBox(
                width: ekranGenisligi / 2.5,
                height: ekranYuksekligi / 17,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(vertical: 15),
                  ),
                  onPressed: () async {
                    if (_tur == null ||
                        _kategori == null ||
                        _tutarcontroller.text.isEmpty ||
                        _tarihcontroller.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Lütfen zorunlu alanları giriniz."),
                        ),
                      );
                      return;
                    }

                    islem yeniIslem= islem(
                      tur: _tur!,
                      kategori: _kategori!,
                      //seçilen tarih varsa onu kullan, yoksa bugünün tarihini al
                      tarih: _secilenTarihNesnesi ?? DateTime.now(),
                      tutar: double.tryParse(_tutarcontroller.text.replaceAll(',', '.')) ?? 0.0, //sayıya çevirmeye çalışır
                      aciklama: _aciklamacontroller.text.isEmpty ? null : _aciklamacontroller.text,
                    );

                    await veritabaniIslemleri().ekle(yeniIslem);
                    if(mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("İşlem başarıyla eklendi!"),
                          backgroundColor:
                          Color(0xFF43A047),
                          duration: Duration(seconds: 2), //snackbar 2 sn görünecek
                        ),
                      );
                    }

                    setState(() {
                      _tutarcontroller.clear();
                      _aciklamacontroller.clear();
                      _tarihcontroller.clear();
                      _secilenTarihNesnesi = null;
                      _tur = null;
                      _kategori = null;
                    });

                  },
                  child: Text(
                    "Ekle",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
