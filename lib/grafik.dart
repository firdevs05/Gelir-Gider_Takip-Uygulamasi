import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'islem_model.dart';
import 'veritabani_islemleri.dart';

class grafik extends StatefulWidget {
  grafik({super.key});

  @override
  State<grafik> createState() => _grafikState();
}

class _grafikState extends State<grafik> {
  String _secilenzaman = "Haftalık";

  List<FlSpot> _gelirNoktalari = [];
  List<FlSpot> _giderNoktalari = [];
  List<String> _altBasliklar = [];
  //veritabanından veriler gelene kadar grafik çökmesin diye
  double _maxYukseklik = 1000;

  List<String> aylar = [
    "Oca",
    "Şub",
    "Mar",
    "Nis",
    "May",
    "Haz",
    "Tem",
    "Ağu",
    "Eyl",
    "Eki",
    "Kas",
    "Ara",
  ];

  @override
  void initState() {
    super.initState();
    verileriGuncelle();
  }

  @override
  Widget build(BuildContext context) {
    double ekranGenisligi = MediaQuery.of(context).size.width;
    double ekranYuksekligi = MediaQuery.of(context).size.height;

    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: "Haftalık",
                    groupValue: _secilenzaman,
                    onChanged: (deger) {
                      setState(() {
                        _secilenzaman = deger!;
                      });
                      verileriGuncelle();
                    },
                  ),
                  const Text("Haftalık"),

                  Radio<String>(
                    value: "Aylık",
                    groupValue: _secilenzaman,
                    onChanged: (deger) {
                      setState(() {
                        _secilenzaman = deger!;
                      });
                      verileriGuncelle();
                    },
                  ),
                  const Text("Aylık"),

                  Radio<String>(
                    value: "Yıllık",
                    groupValue: _secilenzaman,
                    onChanged: (deger) {
                      setState(() {
                        _secilenzaman = deger!;
                      });
                      verileriGuncelle();
                    },
                  ),
                  const Text("Yıllık"),
                ],
              ),
              SizedBox(height: 40),

              SizedBox(
                width: ekranGenisligi / 1.1,
                height: ekranYuksekligi / 2,

                child: _gelirNoktalari.isEmpty && _giderNoktalari.isEmpty
                    ? Center(child: Text("Görüntülenecek veri yok."))
                    : LineChart(
                        LineChartData(
                          gridData: FlGridData(
                            show: true, //ızgarayı göster

                            drawVerticalLine:
                                false, //dikey çizgiler olmasın

                            horizontalInterval:
                            _maxYukseklik > 0 ? _maxYukseklik / 5 : 500, //yatay çizgiler 500'er 500'er olsun

                            getDrawingHorizontalLine: (value) {
                              return FlLine(
                                color: Colors.grey.withOpacity(
                                  0.5,
                                ),
                                strokeWidth: 1, //çizgi kalınlığı
                                dashArray: [
                                  5,
                                  5,
                                ], //[5,5]:kesikli null:düz çizgi
                              );
                            },
                          ),

                          borderData: FlBorderData(
                            show: true,

                            border: Border(
                              bottom: BorderSide(color: Colors.grey, width: 1),

                              left: BorderSide(
                                color: Colors.black,
                              ),
                            ),
                          ),

                          titlesData: FlTitlesData(
                            show: true,

                            rightTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false), //sağ taraf boş
                            ),

                            topTitles: const AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ), // Üst taraf boş

                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                interval: _maxYukseklik > 0 ? _maxYukseklik / 5 : 500, //artış miktarı
                                reservedSize: 40, //sayıların kapladığı alan
                                getTitlesWidget: (value, meta) {
                                  return Text(
                                    value.toInt().toString(),

                                    style: const TextStyle(
                                      fontSize: 12,
                                      color: Colors.grey,
                                    ),
                                  );
                                },
                              ),
                            ),

                            // ALT EKSEN (TARİHLER)
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                reservedSize: 30,
                                interval: 1, //her birimi göster
                                getTitlesWidget: (value, meta) {
                                  int index = value.toInt();

                                  if (index >= 0 &&
                                      index < _altBasliklar.length) {
                                    return SideTitleWidget(
                                      axisSide: meta.axisSide, //konum bilgisi
                                      space: 8, //grafik ve alttaki tarihler arasındaki boşluklar
                                      child: Text(
                                        _altBasliklar[index],
                                        style: TextStyle(fontSize: 10),
                                      ),
                                    );
                                  }
                                  //hata olursa (index listenin dışına taşarsa) boş bir şey basarak hatayı gizliyoruz
                                  return SizedBox.shrink();
                                },
                              ),
                            ),
                          ),

                          //grafiğin min-max değerleri
                          minX: 0,
                          maxX: (_altBasliklar.length - 1).toDouble(),
                          minY: 0,
                          maxY: _maxYukseklik,

                          //çizgiler
                          lineBarsData: [
                            //gelir (yeşil)
                            LineChartBarData(
                              spots: _gelirNoktalari,
                              isCurved: false,
                              color: Colors.green,
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.green.withOpacity(0.1),
                              ),
                            ),

                            //gider (kırmızı)
                            LineChartBarData(
                              spots: _giderNoktalari,
                              isCurved: false,
                              color: Colors.red,
                              barWidth: 3,
                              dotData: FlDotData(show: true),
                              belowBarData: BarAreaData(
                                show: true,
                                color: Colors.red.withOpacity(0.1),
                              ),
                            ),
                          ],
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verileriGuncelle() async {
    List<islem> tumIslemler = await veritabaniIslemleri().islemleriGetir();
    List<FlSpot> gelirTemp = [];
    List<FlSpot> giderTemp = [];
    List<String> baslikTemp = [];
    double maxTutar = 0;
    DateTime bugun = DateTime.now();

    if (_secilenzaman == "Haftalık") {
      for (int i = 6; i >= 0; i--) {
        //bugünden geriye doğru günleri bul
        DateTime oGun = bugun.subtract(Duration(days: i));
        String tarihEtiketi = "${oGun.day} ${aylar[oGun.month-1]}";
        baslikTemp.add(tarihEtiketi);

        //o güne ait işlemleri bul ve topla
        double oGunGelir = 0;
        double oGunGider = 0;

        for (var islem in tumIslemler) {
          if (islem.tarih.year == oGun.year &&
              islem.tarih.month == oGun.month &&
              islem.tarih.day == oGun.day) {
            if (islem.tur == "Gelir")
              oGunGelir += islem.tutar;
            else
              oGunGider += islem.tutar;
          }
        }

        //grafiğe nokta olarak ekle (x: sıra, y: tutar)
        gelirTemp.add(FlSpot((6 - i).toDouble(), oGunGelir));
        giderTemp.add(FlSpot((6 - i).toDouble(), oGunGider));

        //en yüksek tutarı bul
        if (oGunGelir > maxTutar) maxTutar = oGunGelir;
        if (oGunGider > maxTutar) maxTutar = oGunGider;
      }
    }
    else if (_secilenzaman == "Aylık") {
      for (int i = 0; i < 4; i++) {
        baslikTemp.add("${i + 1}. Hafta");
        int baslangicGunu = (i * 7) + 1;
        int bitisGunu = (i == 3) ? 31 : baslangicGunu + 6;
        double oHaftaGelir = 0;
        double oHaftaGider = 0;

        for (var islem in tumIslemler) {
          if (islem.tarih.year == bugun.year &&
              islem.tarih.month == bugun.month) {
            if (islem.tarih.day >= baslangicGunu &&
                islem.tarih.day <= bitisGunu) {
              if (islem.tur == "Gelir")
                oHaftaGelir += islem.tutar;
              else
                oHaftaGider += islem.tutar;
            }
          }
        }

        gelirTemp.add(FlSpot(i.toDouble(), oHaftaGelir));
        giderTemp.add(FlSpot(i.toDouble(), oHaftaGider));
        if (oHaftaGelir > maxTutar) maxTutar = oHaftaGelir;
        if (oHaftaGider > maxTutar) maxTutar = oHaftaGider;
      }
    }
    else {
      for (int i = 1; i <= 12; i++) {
        baslikTemp.add(aylar[i - 1]);

        double oAyGelir = 0;
        double oAyGider = 0;

        for (var islem in tumIslemler) {
          if (islem.tarih.year == bugun.year && islem.tarih.month == i) {
            if (islem.tur == "Gelir")
              oAyGelir += islem.tutar;
            else
              oAyGider += islem.tutar;
          }
        }

        gelirTemp.add(FlSpot((i - 1).toDouble(), oAyGelir));
        giderTemp.add(FlSpot((i - 1).toDouble(), oAyGider));
        if (oAyGelir > maxTutar) maxTutar = oAyGelir;
        if (oAyGider > maxTutar) maxTutar = oAyGider;
      }
    }

    setState(() {
      _gelirNoktalari = gelirTemp;
      _giderNoktalari = giderTemp;
      _altBasliklar = baslikTemp;

      //grafiğin tavanı en yüksek tutardan biraz fazla olsun ki çizgi tepeye yapışmasın
      _maxYukseklik = maxTutar == 0 ? 100 : maxTutar + (maxTutar * 0.2);
    });
  }
}