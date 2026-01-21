import 'package:flutter/material.dart';

class tutarfiltrele extends StatefulWidget {
  const tutarfiltrele({super.key});

  @override
  State<tutarfiltrele> createState() => _tutarfiltreleState();
}

class _tutarfiltreleState extends State<tutarfiltrele> {
  TextEditingController _dusuktutarcontroller = TextEditingController();
  TextEditingController _yuksektutarcontroller = TextEditingController();

  @override
  void dispose() { //hafızadan sil
    _dusuktutarcontroller.dispose();
    _yuksektutarcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double ekranGenisligi = MediaQuery.of(context).size.width;
    double ekranYuksekligi = MediaQuery.of(context).size.height;

    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(50),
        child: Column(
          children: [
            SizedBox(height: 30),
            Text(
              "Tutar aralığını giriniz:",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),

            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _dusuktutarcontroller,
                    keyboardType:
                        TextInputType.number, //sadece sayı klavyesi açılsın
                    decoration: const InputDecoration(
                      labelText: "TL",
                      hintText: "Örn: 100",
                      border:
                          UnderlineInputBorder(), // Sadece alt çizgi (Resimdeki gibi)
                    ),
                  ),
                ),
                const SizedBox(width: 15),
                Text("-"),
                const SizedBox(width: 15),
                Expanded(
                  child: TextFormField(
                    controller: _yuksektutarcontroller,
                    keyboardType:
                        TextInputType.number, //sadece sayı klavyesi açılsın
                    decoration: const InputDecoration(
                      labelText: "" + "TL",
                      hintText: "Örn: 100",
                      border:
                          UnderlineInputBorder(), // Sadece alt çizgi (Resimdeki gibi)
                    ),
                  ),
                ),
              ],
            ),
            Spacer(),

            SizedBox(
              width: ekranGenisligi / 2.5, // Buton genişliği
              height: ekranYuksekligi / 17,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 15),
                ),
                onPressed: () {
                  Navigator.pop(context, {
                    "min":_dusuktutarcontroller.text,
                    "max":_yuksektutarcontroller.text
                  });
                },
                child: Text(
                  "Filtrele",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
