import 'package:flutter/material.dart';
import 'turvekategorifiltrele.dart';
import 'tutarfiltrele.dart';

class filtrele extends StatefulWidget
{
  const filtrele({super.key});

  @override
  State<filtrele> createState() => _filtreleState();
}

class _filtreleState extends State<filtrele>
{
  String? secilenTur;
  String? secilenKategori;
  String? minTutar;
  String? maxTutar;

  @override
  Widget build(BuildContext context) {
    double ekranGenisligi = MediaQuery.of(context).size.width;
    double ekranYuksekligi = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text("Filtrele"),
      ),

      body: Column(
        children: [
          SizedBox(height: 15),
          ListTile(
            title: const Text("Tür/Kategori", style: TextStyle(fontSize: 18)),
            //eğer seçim yapıldıysa altına yaz (örn: gider / kıyafet)
            subtitle: secilenTur != null
                ? Text("$secilenTur ${secilenKategori != null ? '/ $secilenKategori' : ''}", style: TextStyle(color: Color(0xFF008AE6)))
                : null,

            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),

            onTap: () async {
              //sayfaya git ve sonucu bekle
              var sonuc = await Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const turvekategorifiltrele(),
                  ),
              );

              if(sonuc!=null) {
                setState(() {
                  secilenTur = sonuc['tur'];
                  secilenKategori = sonuc['kategori'];
                });
              }
            },
          ),

          ListTile(
            title: const Text("Tutar", style: TextStyle(fontSize: 18)),

            subtitle: minTutar != null && maxTutar != null
                ? Text("$minTutar TL - $maxTutar TL", style: TextStyle(color: Color(0xFF008AE6)))
                : null,

            trailing: const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),

            onTap: () async {
              var sonuc = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const tutarfiltrele(),
                ),
              );

              if (sonuc != null) {
                setState(() {
                  minTutar = sonuc['min'];
                  maxTutar = sonuc['max'];
                });
              }
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
              onPressed: () async {
                Map<String, dynamic> filtreVerileri = {
                  "tur": secilenTur,
                  "kategori": secilenKategori,
                  "min": minTutar,
                  "max": maxTutar,
                };
                Navigator.pop(context,filtreVerileri);
              },
              child: Text(
                "Uygula",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}