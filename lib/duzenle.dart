import 'package:flutter/material.dart';
import 'islem_model.dart';
import 'veritabani_islemleri.dart';

class duzenle extends StatefulWidget
{
  final int id;
  final String mevcuttur;
  final String mevcutkategori;
  final String mevcuttarih;
  final String mevcuttutar;
  final String mevcutaciklama;

  duzenle({
    super.key,
    required this.id,
    required this.mevcuttur,
    required this.mevcutkategori,
    required this.mevcuttarih,
    required this.mevcuttutar,
    required this.mevcutaciklama,
  });

  @override
  State<duzenle> createState()=> _duzenleState();
}

class _duzenleState extends State<duzenle>
{
  String? _secilenTur;
  String? _secilenKategori;
  late TextEditingController _tarihController;
  late TextEditingController _tutarController;
  late TextEditingController _aciklamaController;

  // Tarih nesnesi (SQL için gerekli)
  DateTime? _secilenTarihNesnesi;

  List<String> gelirListesi=["Maaş","Burs","Ek İş","Harçlık","Diğer"];
  List<String> giderListesi=["Ulaşım","Kıyafet","Yemek","Fatura","Market Alışverişi","Diğer"];

  @override
  void initState() {
    super.initState();
    _secilenTur = widget.mevcuttur;
    _secilenKategori = widget.mevcutkategori;
    _tarihController = TextEditingController(text: widget.mevcuttarih);
    _tutarController = TextEditingController(text: widget.mevcuttutar);
    _aciklamaController = TextEditingController(text: widget.mevcutaciklama);
  }

  @override
  void dispose() {
    // Sayfa kapanınca controller'ları bellekten temizle
    _tarihController.dispose();
    _tutarController.dispose();
    _aciklamaController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double ekranGenisligi = MediaQuery.of(context).size.width;
    double ekranYuksekligi = MediaQuery.of(context).size.height;

    List<String> gosterilecekListe;
    gosterilecekListe= _secilenTur=="Gelir" ? gelirListesi : giderListesi;

    return Scaffold(
      body: SingleChildScrollView(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            SizedBox(height: 30),
            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: _secilenTur,
                border: OutlineInputBorder(), // Siyah çerçeve
              ),
              value: _secilenTur, // Şu an seçili olan değer
              items: const [
                DropdownMenuItem(value: "Gelir", child: Text("Gelir")),
                DropdownMenuItem(value: "Gider", child: Text("Gider")),
              ],
              onChanged: (yeniDeger) {
                setState(() {
                  _secilenTur=yeniDeger;
                  _secilenKategori=null;
                });
              },
            ),
            const SizedBox(height: 20),

            DropdownButtonFormField<String>(
              decoration: InputDecoration(
                labelText: _secilenKategori,
                border: OutlineInputBorder(),
              ),
              value: _secilenKategori, // null ise "Seçiniz" gibi boş gelir, hata vermez.

              // Listeyi DropdownMenuItem'a çeviriyoruz
              items: gosterilecekListe.map((String kategoriAdi) {
                return DropdownMenuItem(
                  value: kategoriAdi,
                  child: Text(kategoriAdi),
                );
              }).toList(),

              onChanged: (yeniDeger) {
                setState(() {
                  _secilenKategori = yeniDeger;
                });
              },
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _tarihController,
              readOnly: true, // Elle yazmayı engelle
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                suffixIcon: Icon(Icons.keyboard_arrow_down),
              ),
              onTap: () async {
                // Tıklanınca Takvim Aç
                DateTime? secilenTarih = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2030),
                  locale: const Locale('tr', 'TR'),
                );

                if (secilenTarih != null) {
                  setState(() {
                    _tarihController.text =
                    "${secilenTarih.day}/${secilenTarih.month}/${secilenTarih.year}";
                    _secilenTarihNesnesi=secilenTarih;
                  });
                }
              },
            ),
            const SizedBox(height: 30),

            TextFormField(
              controller: _tutarController,
              keyboardType: TextInputType.number, // Sayı klavyesi
              decoration: const InputDecoration(
                border: UnderlineInputBorder(), // Sadece alt çizgi
                hintText: "Tutar",
              ),
              style: const TextStyle(fontSize: 18),
            ),
            const SizedBox(height: 30),

            TextFormField(
              controller: _aciklamaController,
              decoration: const InputDecoration(
                border: UnderlineInputBorder(),
                hintText: "Açıklama (isteğe bağlı)",
              ),
              style: const TextStyle(fontSize: 18),
            ),
            SizedBox(height: 50),

            SizedBox(
              width: ekranGenisligi/2.5,
              height: ekranYuksekligi/17,
              child: ElevatedButton(
                  onPressed: () async {
                    if (_secilenTur == null ||
                        _secilenKategori == null ||
                        _tutarController.text.isEmpty ||
                        _tarihController.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text("Lütfen zorunlu alanları giriniz."),
                        ),
                      );
                      return;
                    }

                    islem guncellenecekIslem= islem(
                      id: widget.id,
                      tur: _secilenTur!,
                      kategori: _secilenKategori!,
                      //seçilen tarih varsa onu kullan, yoksa bugünün tarihini al
                      tarih: _secilenTarihNesnesi ?? DateTime.now(),
                      //kullanıcı virgüllü değer girdiyse noktaya çevir, ondalık sayıya çevrilmezse sonucu null yap,
                      //sonuç nullsa tutarı 0.0 olarak güncelle
                      tutar: double.tryParse(_tutarController.text.replaceAll(',', '.')) ?? 0.0,
                      aciklama: _aciklamaController.text.isEmpty ? null : _aciklamaController.text,
                    );

                    await veritabaniIslemleri().guncelle(guncellenecekIslem);
                    if(mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text("Kayıt başarıyla güncellendi!"),
                          backgroundColor:
                          Color(0xFF43A047),
                        ),
                      );

                      Navigator.pop(context, guncellenecekIslem);
                    }

                    //işlem bitince bir önceki sayfaya dön
                    Navigator.pop(context);
                  },
                child: Text(
                  "Güncelle",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}