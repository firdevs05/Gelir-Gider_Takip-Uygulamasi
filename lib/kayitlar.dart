import 'package:flutter/material.dart';
import 'detaylar.dart';
import 'islem_model.dart';
import 'veritabani_islemleri.dart';
import 'filtrele.dart';

class kayitlar extends StatefulWidget {
  const kayitlar({super.key});

  @override
  State<kayitlar> createState() => _kayitlarState();
}

class _kayitlarState extends State<kayitlar> {
  List<islem> _islemlerListesi=[];

  @override
  void initState() {
    super.initState();
    verileriGetir();
  }

  void verileriGetir() async {
    var gelenListe=await veritabaniIslemleri().islemleriGetir();
    setState(() {
      _islemlerListesi=gelenListe;
    });
  }

  void verileriFiltreliGetir(Map<String, dynamic> filtreler) async {
    var yeniListe = await veritabaniIslemleri().filtreliIslemleriGetir(filtreler);

    setState(() {
      _islemlerListesi = yeniListe;
    });
  }

  Map<String, List<islem>> islemleriGrupla(List<islem> liste) {
    Map<String, List<islem>> gruplanmisVeri = {};

    for (var islem in liste) {
      String tarihBasligi = _tarihFormatla(islem.tarih);

      if (!gruplanmisVeri.containsKey(tarihBasligi)) {
        gruplanmisVeri[tarihBasligi] = []; //o tarih için yeni liste oluştur
      }
      gruplanmisVeri[tarihBasligi]!.add(islem);
    }
    return gruplanmisVeri;
  }

  String _tarihFormatla(DateTime tarih) {
    List<String> aylar = [
      "", "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
      "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"
    ];
    return "${tarih.day} ${aylar[tarih.month]}";
  }

  @override
  Widget build(BuildContext context) {

    Map<String, List<islem>> gruplanmisIslemler = islemleriGrupla(_islemlerListesi);
    List<String> tarihAnahtarlari = gruplanmisIslemler.keys.toList();

    return Scaffold(
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              InkWell(
                //kullanıcı geri döndüğünde veriyi yakalamak için async. git ve dönene kadar bekle
                onTap: () async {
                  var gelenFiltreler = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => const filtrele()),
                  );
                  if (gelenFiltreler != null) {
                    verileriFiltreliGetir(gelenFiltreler);
                  }
                },
                child: Row(
                  children: [
                    const Icon(
                      Icons.filter_alt_outlined,
                      size: 30,
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      "Filtrele",
                      style: TextStyle(color: Colors.black, fontSize: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              Expanded(
                child: _islemlerListesi.isEmpty
                    ? const Center(child: Text("Henüz kayıt yok."))
                    : ListView.builder(
                  itemCount: tarihAnahtarlari.length,
                  itemBuilder: (context, index) {
                    String tarihBasligi = tarihAnahtarlari[index];
                    List<islem> gununIslemleri = gruplanmisIslemler[tarihBasligi]!;

                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                tarihBasligi,
                                style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500
                                ),
                              ),
                              const Divider(color: Colors.black, thickness: 1), //altındaki çizgi
                            ],
                          ),
                        ),

                        ...gununIslemleri.map((islem) {

                          bool giderMi = islem.tur == "Gider";
                          String tutarMetni = "${giderMi ? '-' : '+'}${islem.tutar.toStringAsFixed(0)} TL";

                          return InkWell(
                            onTap: () async {
                              await Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => detaylar(
                                    id: islem.id!,
                                    tur: islem.tur,
                                    kategori: islem.kategori,
                                    tarih: _tarihFormatla(islem.tarih),
                                    tutar: tutarMetni,
                                    aciklama: islem.aciklama ?? "",
                                  ),
                                ),
                              );
                              verileriGetir();
                            },
                            child: _gelir_gider_karti(
                                islem.kategori,
                                islem.aciklama ?? islem.tur,
                                tutarMetni,
                            ),
                          );
                        }).toList(),
                        const SizedBox(height: 10),

                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        ),
      );
  }

  Widget _gelir_gider_karti(String kategori, String aciklama, String tutar) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFB3E5FC)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Kategori: $kategori",
                style: TextStyle(fontSize: 12, color: Colors.grey[700]),
              ),
              Text(
                aciklama,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          Text(
            tutar,
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}