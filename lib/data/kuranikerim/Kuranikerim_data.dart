import 'package:huzurvakti/data/kuranikerim/ayetler.dart';
import 'package:huzurvakti/data/kuranikerim/sureler.dart';
import 'package:path/path.dart';
import 'package:huzurvakti/models/ayet.dart';
import 'package:sqflite/sqflite.dart';
import '../../models/sure.dart';

class KuraniKerimDatabeManager {
  Database? _database;

  Future<void> initializeDatabase() async {
    if(_database != null)
      return;
    try {
      String databasesPath = await getDatabasesPath();
      String path = join(databasesPath, 'your_database.db');
      _database = await openDatabase(path, version: 1,
          onCreate: (Database db, int version) async {
            await db.execute(
                'CREATE TABLE Sures(id INTEGER PRIMARY KEY, aciklama TEXT, cuz INTEGER, isim TEXT, isim_Ar TEXT, sayfa INTEGER, sure INTEGER, yer TEXT, ayet_sayisi INTEGER)');
            await db.execute(
                'CREATE TABLE Ayets(id INTEGER PRIMARY KEY, ayet INTEGER, sure INTEGER, text TEXT, text_ar TEXT, text_kelimeler TEXT, text_okunus TEXT)');
          });
    } catch (ex) {
      print('Error: $ex');
    }
    await createData();
  }

  Future<void> createData() async{
    if((await getSureList()).length != 114){
      await _database!.delete("Sures");
     await _insertSureList(sureler);
    }
    if((await getAyetList()).length == 0){
      await _insertAyetList(ayetler);
    }
  }

  Future<void> _insertSureList(List<Map<String, dynamic>> sureList) async {
    await initializeDatabase();
    Batch batch = _database!.batch();
    for (var sure in sureList) {
      batch.insert('Sures', sure);
    }
    await batch.commit(noResult: true);
    print("bitti");
  }

  Future<List<Sure>> getSureList() async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(
      'Sures',
      orderBy: 'sure ASC', // 'sure' sütununa göre artan sıralama
    );
    return List.generate(maps.length, (i) {
      return Sure(
        aciklama: maps[i]['aciklama'],
        ayetSayisi: maps[i]['ayet_sayisi'],
        cuz: maps[i]['cuz'],
        isim: maps[i]['isim'],
        isimAr: maps[i]['isim_ar'],
        sayfa: maps[i]['sayfa'],
        sure: maps[i]['sure'],
        yer: maps[i]['yer'],
      );
    });
  }

  Future<void> _insertAyetList(List<Map<String, dynamic>> ayetList) async {
    await initializeDatabase();
    Batch batch = _database!.batch();
    for (var ayet in ayetList) {
      batch.insert('Ayets', ayet);
    }
    await batch.commit(noResult: true);
    print("bitti");
  }

  Future<List<Ayet>> getAyetList() async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query('Ayets');
    return List.generate(maps.length, (i) {
      return Ayet(
        ayet: maps[i]['ayet'],
        sure: maps[i]['sure'],
        text: maps[i]['text'],
        textAr: maps[i]['text_ar'],
        textKelimeler: maps[i]['text_kelimeler'],
        textOkunus: maps[i]['text_okunus'],
      );
    });
  }

  Future<List<Ayet>> getAyetsBySure(int sure) async {
    await initializeDatabase();
    final List<Map<String, dynamic>> maps = await _database!.query(
      'Ayets',
      where: 'sure = ?', // 'sure' sütununu belirli bir değere eşitle
      whereArgs: [sure], // sure değişkenine göre filtreleme
      orderBy: 'ayet ASC', // 'ayet' sütununa göre artan sıralama
    );
    return List.generate(maps.length, (i) {
      return Ayet(
        ayet: maps[i]['ayet'],
        sure: maps[i]['sure'],
        text: maps[i]['text'],
        textAr: maps[i]['text_ar'],
        textKelimeler: maps[i]['text_kelimeler'],
        textOkunus: maps[i]['text_okunus'],
      );
    });
  }

}