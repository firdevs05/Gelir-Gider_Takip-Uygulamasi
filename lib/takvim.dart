import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:gelir_gider_takip/veritabani_islemleri.dart';
import 'package:gelir_gider_takip/islem_model.dart';
import 'detaylar.dart';

class takvim extends StatefulWidget {
  takvim({super.key});

  @override
  State<takvim> createState() => _takvimState();
}

class _takvimState extends State<takvim>
{
  DateTime _bugun = DateTime.now();
  DateTime? _secilenGun;
  List<islem> _tumIslemler = [];
  List<islem> _ekrandaGosterilenler = [];

  @override
  void initState() {
    super.initState();
    _secilenGun = _bugun;
    verileriGetir();
  }

  void verileriGetir() async {
    var gelenListe = await veritabaniIslemleri().islemleriGetir();

    setState(() {
      _tumIslemler = gelenListe;
      //bugünün verilerini filtrele
      _ekrandaGosterilenler = gunlukIslemleriGetir(_secilenGun!, _tumIslemler);
    });
  }
  //tarihi stringe çevirir
  String _tarihFormatla(DateTime tarih) {
    List<String> aylar = ["Ocak", "Şubat", "Mart", "Nisan", "Mayıs", "Haziran", "Temmuz", "Ağustos", "Eylül", "Ekim", "Kasım", "Aralık"];
    return "${tarih.day} ${aylar[tarih.month-1]}";
  }

  List<islem> gunlukIslemleriGetir(DateTime secilenTarih, List<islem> tumListe) {
    List<islem> oGununIslemleri = [];
    for (var islem in tumListe) {
      if (isSameDay(islem.tarih, secilenTarih)) {
        oGununIslemleri.add(islem);
      }
    }
    return oGununIslemleri;
  }

  void _gunSecildi(DateTime secilen, DateTime focused) {
    setState(() {
      _secilenGun = secilen;
      _bugun = focused; //takvimin o anki odağını güncelle
      _ekrandaGosterilenler = gunlukIslemleriGetir(secilen, _tumIslemler);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(10),
            padding: EdgeInsets.only(bottom: 10),
            decoration: BoxDecoration(
              color: Colors.white,
              border: Border.all(color: Color(0xFFB3E5FC)),
              borderRadius: BorderRadius.circular(20),
            ),
            child: TableCalendar(
              locale: 'tr_TR',
              focusedDay: _bugun,
              firstDay: DateTime.utc(2020,1,1),
              lastDay: DateTime.utc(2030,1,1),

              selectedDayPredicate: (gun) {
                return isSameDay(_secilenGun, gun);
              },
              onDaySelected: _gunSecildi,

              headerStyle: HeaderStyle(
                formatButtonVisible: false, // "2 weeks" yazan butonu gizle
                titleCentered: true,
                titleTextStyle: TextStyle(
                    color: Color(0xFF008AE6),
                    fontSize: 18,
                    fontWeight: FontWeight.bold
                ),
              ),

              calendarStyle: CalendarStyle(
                selectedDecoration: BoxDecoration(
                  color: Color(0xFFCCF2FF),
                  shape: BoxShape.circle,
                ),
                selectedTextStyle: TextStyle(
                    color: Color(0xFF008AE6),
                    fontWeight: FontWeight.bold
                ),

                todayDecoration: BoxDecoration(
                  color: Colors.black12,
                  shape: BoxShape.circle,
                ),
                todayTextStyle: TextStyle(
                    color: Color(0xFF008AE6),
                    fontWeight: FontWeight.bold
                ),
              ),
            ),
          ),

          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10),
            child: Align( //sola yaslamak için
              alignment: Alignment.centerLeft, //dikeyde tam ortaya, yatayda en sola yaslamak için
              child: Text(
                "Gelir/gider durumu:",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          Expanded(
            child: _ekrandaGosterilenler.isEmpty
                ? Center(child: Text("Bu tarihte işlem yok."))
                : ListView.builder(
              padding: EdgeInsets.symmetric(horizontal: 20),
              itemCount: _ekrandaGosterilenler.length,
              itemBuilder: (context, index) {
                var islem = _ekrandaGosterilenler[index];

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
              },
            ),
          ),
        ],
      ),
    );
  }
  Widget _gelir_gider_karti(String kategori, String aciklama, String tutar)
  {
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.all(15),
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