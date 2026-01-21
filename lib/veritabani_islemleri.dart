import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:gelir_gider_takip/islem_model.dart';

class veritabaniIslemleri
{
  //singleton: uygulamanın her yerinde tek bir nesne kullanılır
  //instance: her sayfada veritabanı bağlantısı açıp belleği yormamak için
  static final veritabaniIslemleri _instance=veritabaniIslemleri._internal(); //internal: private bir kurucu metot
  factory veritabaniIslemleri()=>_instance;
  veritabaniIslemleri._internal();

  static Database? _database;

  Future<Database> get database async { //future: işlemin sonucu ileride gelecek
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    //telefonda uygulamaya ayrılan klasörü bulup db dosyasını oraya atar.
    String path = join(await getDatabasesPath(), 'gelirgider_takip.db');

    return await openDatabase(
      path, //veritabanı yolu
      version: 1,
      onCreate: _onCreate, //telefonun hafızasında dosya yoksa çalışır
    );
  }

  Future _onCreate(Database db, int version) async
  {
    await db.execute(
      '''create table islemler(
        id integer primary key autoincrement,
        tur text not null,
        kategori text not null,
        tarih text not null, --DateTime verisi String (ISO8601) olarak saklanacak
        tutar real not null,
        aciklama text
      )'''
    );
  }

  //veri ekle
  Future<int> ekle(islem islem) async {
    Database db = await database;
    return await db.insert('islemler', islem.toMap());
  }

  //verileri getir (yeniden eskiye)
  Future<List<islem>> islemleriGetir() async {
    Database db = await database;
    List<Map<String, dynamic>> maps = await db.query('islemler', orderBy: "tarih DESC");

    return List.generate(maps.length, (i) {
      return islem.fromMap(maps[i]);
    });
  }

  //güncelle
  Future<int> guncelle(islem islem) async {
    Database db = await database;
    return await db.update(
      'islemler',
      islem.toMap(),
      where: 'id = ?',
      whereArgs: [islem.id],
    );
  }

  //sil
  Future<int> sil(int id) async {
    Database db = await database;
    return await db.delete(
      'islemler',
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<double> toplamHesapla(String tur, DateTime baslangic, DateTime bitis) async {
    Database db = await database;
    String baslangicStr = baslangic.toIso8601String();
    String bitisStr = bitis.toIso8601String();

    final sonuc = await db.rawQuery( //içine kendi istediğimiz sorguyu yazabiliriz
    '''select sum(tutar) as toplam 
      from islemler 
      where tur = ? and tarih >= ? and tarih <= ?
    ''', [tur, baslangicStr, bitisStr]);

    if (sonuc.first['toplam'] != null) {
      return sonuc.first['toplam'] as double;
    }
    return 0.0;
  }

  Future<islem?> enUclariHesapla(String tur, bool encokmu, DateTime baslangic, DateTime bitis) async
  {
    Database db=await database;

    String baslangicStr = baslangic.toIso8601String();
    String bitisStr = bitis.toIso8601String();
    String siralamayonu=encokmu ? "desc" : "asc";

    List<Map<String, dynamic>> maps=await db.query(
      'islemler',
      where: 'tur=? and tarih>=? and tarih<=?',
      whereArgs: [tur, baslangicStr, bitisStr],
      orderBy: 'tutar $siralamayonu',
      limit: 1 //sadece en tepedekini getir
    );

    if(maps.isNotEmpty) {
      return islem.fromMap(maps.first);
    }
    return null;
  }

  Future<List<islem>> filtreliIslemleriGetir(Map<String, dynamic> filtreler) async {
    Database db = await database;

    String sorgu = "select * from islemler";
    List<dynamic> argumanlar = [];
    List<String> sartlar = [];

    //tür seçildi mi?
    if (filtreler['tur'] != null) {
      sartlar.add("tur = ?");
      argumanlar.add(filtreler['tur']);
    }

    if (filtreler['kategori'] != null) {
      sartlar.add("kategori = ?");
      argumanlar.add(filtreler['kategori']);
    }

    if (filtreler['min'] != null && filtreler['min'].toString().isNotEmpty) {
      sartlar.add("tutar >= ?");
      argumanlar.add(double.tryParse(filtreler['min']) ?? 0);
    }

    if (filtreler['max'] != null && filtreler['max'].toString().isNotEmpty) {
      sartlar.add("tutar <= ?");
      argumanlar.add(double.tryParse(filtreler['max']) ?? 9999999);
    }

    if (sartlar.isNotEmpty) {
      sorgu += " where " + sartlar.join(" and ");
    }

    sorgu += " order by tarih desc";

    //sorguyu çalıştır
    final List<Map<String, dynamic>> maps = await db.rawQuery(sorgu, argumanlar);

    //her bir mapi nesne haline getirir
    return List.generate(maps.length, (i) {
      return islem.fromMap(maps[i]);
    });
  }
}