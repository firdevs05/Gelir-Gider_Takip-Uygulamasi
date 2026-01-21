import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/duzenle.dart';
import 'veritabani_islemleri.dart';
import 'islem_model.dart';

class detaylar extends StatefulWidget {
  //dışarıdan gelecek veriler
  final int id;
  final String tur;
  final String kategori;
  final String tarih;
  final String tutar;
  final String aciklama;

  detaylar({
    super.key,
    required this.id,
    required this.tur,
    required this.kategori,
    required this.tarih,
    required this.tutar,
    required this.aciklama,
  });

  @override
  State<detaylar> createState() => _detaylarState();
}

class _detaylarState extends State<detaylar>
{
  late String ekrandakiTur;
  late String ekrandakiKategori;
  late String ekrandakiTarih;
  late String ekrandakiTutar;
  late String ekrandakiAciklama;

  @override
  void initState() {
    super.initState();
    //ilk açılışta dışarıdan gelen (widget.) verileri değişkenlere atıyoruz
    ekrandakiTur = widget.tur;
    ekrandakiKategori = widget.kategori;
    ekrandakiTarih = widget.tarih;
    ekrandakiTutar = widget.tutar;
    ekrandakiAciklama = widget.aciklama;
  }

  String _tarihFormatla(DateTime tarih) {
    List<String> aylar = ["", "Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran",
      "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"];
    return "${tarih.day} ${aylar[tarih.month]}";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            SizedBox(height: 20),

            _bilgiSatiri("Tür:", ekrandakiTur),
            SizedBox(height: 10),
            _bilgiSatiri("Kategori:", ekrandakiKategori),
            SizedBox(height: 10),
            _bilgiSatiri("Tarih:", ekrandakiTarih),
            SizedBox(height: 10),
            _bilgiSatiri("Tutar:", ekrandakiTutar),
            SizedBox(height: 10),
            _bilgiSatiri("Açıklama:", ekrandakiAciklama),

            const Spacer(),

            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () async {
                      String temizTutar = ekrandakiTutar
                          .replaceAll(" TL", "")
                          .replaceAll("+", "")
                          .replaceAll("-", "")
                          .trim();

                      final guncelVeri=await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => duzenle(
                            id: widget.id,
                            mevcuttur: ekrandakiTur,
                            mevcutkategori: ekrandakiKategori,
                            mevcuttarih: ekrandakiTarih,
                            mevcuttutar: temizTutar,
                            mevcutaciklama: ekrandakiAciklama,
                          ),
                        ),
                      );

                      if (guncelVeri != null && guncelVeri is islem) {
                        setState(() {
                          ekrandakiTur = guncelVeri.tur;
                          ekrandakiKategori = guncelVeri.kategori;
                          ekrandakiTarih = _tarihFormatla(guncelVeri.tarih);
                          ekrandakiAciklama = guncelVeri.aciklama ?? "";

                          bool giderMi = guncelVeri.tur == "Gider";
                          ekrandakiTutar = "${giderMi ? '-' : '+'}${guncelVeri.tutar.toStringAsFixed(0)} TL";
                        });
                      }
                    },
                    child: Text(
                      "Düzenle",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 20),

                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 15),
                    ),
                    onPressed: () async {
                      await veritabaniIslemleri().sil(widget.id);
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Sil",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
  Widget _bilgiSatiri(String baslik, String deger)
  {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 15),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 90,
            child: Text(
              baslik,
              style: const TextStyle(
                color: Color(0xFF4FC3F7),
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Text(
              deger,
              style: const TextStyle(fontSize: 16, color: Colors.black87),
            ),
          ),
        ],
      ),
    );
  }
}
