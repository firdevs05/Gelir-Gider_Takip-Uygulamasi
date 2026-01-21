import 'package:flutter/material.dart';

class turvekategorifiltrele extends StatefulWidget
{
  const turvekategorifiltrele({super.key});

  @override
  State<turvekategorifiltrele> createState() => _turvekategorifiltreleState();
}

class _turvekategorifiltreleState extends State<turvekategorifiltrele>
{
  String? _tur, _kategori;

  @override
  Widget build(BuildContext context) {
    double ekranGenisligi = MediaQuery.of(context).size.width;
    double ekranYuksekligi = MediaQuery.of(context).size.height;

    List<String> gelirListesi=["Maaş","Burs","Ek İş","Harçlık","Diğer"];
    List<String> giderListesi=["Ulaşım","Kıyafet","Yemek","Fatura","Market Alışverişi","Diğer"];
    List<String> gosterilecekListe;
    gosterilecekListe= _tur=="Gelir" ? gelirListesi : giderListesi;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            SizedBox(height: 50),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: "Tür (*)",
                border: OutlineInputBorder(),
              ),
              value: _tur,
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
            Spacer(),

            SizedBox(
              width: ekranGenisligi / 2.5,
              height: ekranYuksekligi / 17,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    "tur":_tur,
                    "kategori":_kategori
                  });
                },
                child: Text(
                  "Filtrele",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}