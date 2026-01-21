class islem
{
  int? id;
  String tur;
  String kategori;
  DateTime tarih;
  double tutar;
  String? aciklama;

  islem ({
    this.id,
    required this.tur,
    required this.kategori,
    required this.tarih,
    required this.tutar,
    this.aciklama,
  });

  //veritabanına kaydederken classı mape çevirmeliyiz
  Map<String,dynamic> toMap() //dynamic her türlü tipi alabilir
  {
    return
      {
        'id':id,
        'tur':tur,
        'kategori':kategori,
        'tarih':tarih.toIso8601String(), //veritabanına string olarak kaydeder
        'tutar':tutar,
        'aciklama':aciklama,
      };
  }

  //veritabanından okurken mapi classa çevirmeliyiz
  factory islem.fromMap(Map<String,dynamic> map) //factory veritabanından gelen mapin verisini alıp gerekli dönüşümleri yapıp islem nesnesi döndürür
  {
    return islem(
      id: map['id'],
      tur: map['tur'],
      kategori: map['kategori'],
      tarih: DateTime.parse(map['tarih']),
      tutar: map['tutar'],
      aciklama: map['aciklama'],
    );
  }
}