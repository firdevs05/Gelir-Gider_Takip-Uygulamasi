import 'package:flutter/material.dart';
import 'package:gelir_gider_takip/sayfa_gecisleri.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async { //asenkron
  WidgetsFlutterBinding.ensureInitialized(); //flutter ve os arasındaki bağlantıyı manuel olarak başlatır
  await initializeDateFormatting('tr_TR', null); //runappten önce çalışır, o yüzden await yaptım
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gelir Gider Takip',
      debugShowCheckedModeBanner: false,

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate, //android widgetların yazıları
        GlobalWidgetsLocalizations.delegate, //yazı yönü
        GlobalCupertinoLocalizations.delegate, //ios widgetların yazıları
      ],
      supportedLocales: const [
        Locale('tr', 'TR'),
      ],
      locale: const Locale('tr', 'TR'), // Varsayılan dil Türkçe olsun

      theme: ThemeData(
        useMaterial3: true,

        //buton tasarımı
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Color.fromRGBO(204, 242, 255, 1),
            foregroundColor: Color.fromRGBO(0, 138, 230, 1),
            //elevation: 0 //gölge ekler, 0 olursa gölge yok
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),

        //appbar tasarımı
        appBarTheme: AppBarThemeData(
          backgroundColor: Color.fromRGBO(204, 242, 255, 1),
          titleTextStyle: TextStyle(
            color: Color.fromRGBO(0, 138, 230, 1),
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),

        //alt menü (bottom navigation) tasarımı
        bottomNavigationBarTheme: BottomNavigationBarThemeData(
          backgroundColor: Color.fromRGBO(204, 242, 255, 1),
          selectedItemColor: Colors.white,
          unselectedItemColor: Color.fromRGBO(0, 138, 230, 1),
          type: BottomNavigationBarType.fixed,
        ),
        scaffoldBackgroundColor: Colors.white,
      ),
      home: sayfa_gecisleri(),
    );
  }
}
