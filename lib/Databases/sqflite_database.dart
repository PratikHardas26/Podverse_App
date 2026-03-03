import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class SqfliteDatabase {
  Future<Database> createDB() async {
    Database db = await openDatabase(
      join(await getDatabasesPath(), "PodverseDB.db"),
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE Podverse(
              id INTEGER PRIMARY KEY AUTOINCREMENT,
              name 
          
          )
          ''');
      },
    );
    return db;
  }
}
