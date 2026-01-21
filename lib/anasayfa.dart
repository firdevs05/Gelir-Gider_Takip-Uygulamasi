import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/veritabani_islemleri.dart';
import 'package:gelir_gider_takip/islem_model.dart';

class anasayfa extends StatefulWidget {
  anasayfa({super.key});

  @override
  State<anasayfa> createState() => _anasayfaState();
}

class _anasayfaState extends State<anasayfa> {
  String _secilenzaman = "Haftalık";
  double toplamGelir=0.0;
  double toplamGider=0.0;
  double netDurum=0.0;
  islem? enYuksekGelir;
  islem? enDusukGelir;
  islem? enYuksekGider;
  islem? enDusukGider;

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
          padding: EdgeInsets.all(10.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Radio<String>(
                    value: "Haftalık",
                    groupValue: _secilenzaman, //şu an seçili olan değişkeni tutar
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

              Container(
                margin: EdgeInsets.only(top: 15),
                height: ekranYuksekligi / 5,
                width: ekranGenisligi / 1.1,
                padding: EdgeInsets.all(10),
                decoration: BoxDecoration(
                  border: Border.all(color: Color(0xFFB3E5FC)),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, //yatay eksen, ana yönü dikey eksen
                  children: [
                    Center(
                      child: Text(
                        "Gelir/Gider Durumu",
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Gelir: ${toplamGelir}", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 7),
                    Text("Gider: ${toplamGider}", style: TextStyle(fontSize: 18)),
                    SizedBox(height: 7),
                    Text("Net: ${netDurum}", style: TextStyle(fontSize: 18)),
                  ],
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: ekranYuksekligi / 4.5,
                        margin: EdgeInsets.only(left: 5, right: 5, top: 15),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFB3E5FC)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "En Çok Gelir\nGetiren Kategori",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),

                            Text(
                              enYuksekGelir?.kategori ?? "Veri yok.", //varsa kategoriyi yaz, yoksa "Veri Yok"
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            SizedBox(height: 3),
                            Text(
                              enYuksekGelir!=null ? "(${enYuksekGelir!.tutar.toStringAsFixed(0)} TL)" : "(0 TL)", //virgülden sonraki 0 sayıyı göster
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        height: ekranYuksekligi / 4.5,
                        margin: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 15,
                        ),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFB3E5FC)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "En Az Gelir\nGetiren Kategori",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),

                            Text(
                              enDusukGelir?.kategori ?? "Veri yok.",
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            SizedBox(height: 3),
                            Text(
                              enDusukGelir!=null ? "(${enDusukGelir!.tutar.toStringAsFixed(0)} TL)" : "(0 TL)",
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 15.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Container(
                        height: ekranYuksekligi / 4.5,
                        margin: EdgeInsets.only(left: 5, right: 5, top: 15),
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFB3E5FC)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "En Çok Harcama\nYapılan Kategori",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),

                            Text(
                              enYuksekGider?.kategori ?? "Veri yok.",
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            SizedBox(height: 3),
                            Text(
                              enYuksekGider!=null ? "(${enYuksekGider!.tutar.toStringAsFixed(0)} TL)" : "(0 TL)",
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      child: Container(
                        height: ekranYuksekligi / 4.5,
                        margin: EdgeInsets.only(
                          left: 15,
                          right: 15,
                          top: 15,
                        ), // Soldakiyle yapışmasın
                        padding: EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          border: Border.all(color: Color(0xFFB3E5FC)),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Center(
                              child: Text(
                                "En Az Harcama\nYapılan Kategori",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            SizedBox(height: 15),

                            Text(
                              enDusukGider?.kategori ?? "Veri yok.",
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                            SizedBox(height: 3),
                            Text(
                              enDusukGider!=null ? "(${enDusukGider!.tutar.toStringAsFixed(0)} TL)" : "(0 TL)",
                              style: TextStyle(fontSize: 18, color: Colors.black),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void verileriGuncelle() async {
    veritabaniIslemleri db =veritabaniIslemleri();
    DateTime simdi = DateTime.now();
    DateTime baslangic;
    DateTime bitis;

    if (_secilenzaman == "Haftalık") {
      baslangic = simdi.subtract(Duration(days: simdi.weekday - 1)); //weekday=pazartesi
      baslangic = DateTime(baslangic.year, baslangic.month, baslangic.day); //tarihi günün başına çek
      bitis = DateTime(simdi.year, simdi.month, simdi.day, 23, 59, 59); //haftanın sonu
    }
    else if (_secilenzaman == "Aylık") {
      baslangic = DateTime(simdi.year, simdi.month, 1);
      bitis = DateTime(simdi.year, simdi.month + 1, 0, 23, 59, 59); //gelecek ayın 0. günü=bu ayın son günü
    }
    else {
      baslangic = DateTime(simdi.year, 1, 1);
      bitis = DateTime(simdi.year, 12, 31, 23, 59, 59);
    }

    double gelenGelir = await db.toplamHesapla("Gelir", baslangic, bitis);
    double gelenGider = await db.toplamHesapla("Gider", baslangic, bitis);
    islem? gelenEnYuksekGelir=await db.enUclariHesapla("Gelir", true, baslangic, bitis);
    islem? gelenEnDusukGelir=await db.enUclariHesapla("Gelir", false, baslangic, bitis);
    islem? gelenEnYuksekGider=await db.enUclariHesapla("Gider", true, baslangic, bitis);
    islem? gelenEnDusukGider=await db.enUclariHesapla("Gider", false, baslangic, bitis);

    if(mounted) // sayfa hala açıksa güncelle (hata almamak için güvenlik)
    {
      setState(() {
        toplamGelir = gelenGelir;
        toplamGider = gelenGider;
        netDurum = toplamGelir - toplamGider;

        enYuksekGelir=gelenEnYuksekGelir;
        enDusukGelir=gelenEnDusukGelir;
        enYuksekGider=gelenEnYuksekGider;
        enDusukGider=gelenEnDusukGider;
      });
    }
  }
}
