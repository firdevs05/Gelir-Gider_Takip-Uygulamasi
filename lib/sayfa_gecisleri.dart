import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/anasayfa.dart';
import 'package:gelir_gider_takip/kayitlar.dart';
import 'package:gelir_gider_takip/ekle.dart';
import 'package:gelir_gider_takip/grafik.dart';
import 'package:gelir_gider_takip/takvim.dart';

class sayfa_gecisleri extends StatefulWidget
{
  sayfa_gecisleri({super.key});

  @override
  State<sayfa_gecisleri> createState()=> _sayfa_gecisleriState();
}

class _sayfa_gecisleriState extends State<sayfa_gecisleri>
{
  int _sayfaindex=0;
  final List<Widget> _sayfalar= [
    anasayfa(),
    kayitlar(),
    ekle(),
    grafik(),
    takvim(),
  ];

  final List<String> _basliklar= [
    "Anasayfa",
    "Kayıtlar",
    "Ekle",
    "Grafik",
    "Takvim",
  ];

  void _sayfaDegistir(int index)
  {
    setState(() {
      _sayfaindex=index;
    });
  }

  @override
  Widget build(BuildContext context)
  {
    return Scaffold(
      //appbar
      appBar: AppBar(
        title: Text(_basliklar[_sayfaindex]),
      ),
      // Gövde: Seçili olan sayfayı gösterir
      body: _sayfalar[_sayfaindex],

      //alt menü
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _sayfaindex,
        onTap: _sayfaDegistir,
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "Anasayfa",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt_long),
            label: "Kayıtlar",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.add_circle, size: 40),
            label: "Ekle",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: "Grafik",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_month),
            label: "Takvim",
          ),
        ],
      ),
    );
  }
}