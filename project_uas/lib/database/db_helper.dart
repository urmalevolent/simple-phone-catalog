import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../model/hp_local.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;
  DbHelper._internal();

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDb();
    return _database!;
  }

  Future<Database> _initDb() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'hp_katalog.db');

    return await openDatabase(
  path,
  version: 2, 
  onCreate: _onCreate,
  onUpgrade: (db, oldVersion, newVersion) async {
    // Hapus dan buat ulang tabel
    await db.execute('DROP TABLE IF EXISTS hp');
    await _onCreate(db, newVersion);
  },
);
  }

  Future<void> _onCreate(Database db, int version) async {
   await db.execute('''
  CREATE TABLE hp(
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    merk TEXT,
    battery TEXT,      
    ram INTEGER,
    harga INTEGER,
    deskripsi TEXT,
    gambar TEXT
  )
''');

  }

  Future<int> insertHp(HpLocal hp) async {
    final db = await database;
    return await db.insert('hp', hp.toMap());
  }

  Future<List<HpLocal>> getAllHp() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query('hp');

    return List.generate(maps.length, (i) {
      return HpLocal.fromMap(maps[i]);
    });
  }

  Future<int> updateHp(HpLocal hp) async {
    final db = await database;
    return await db.update(
      'hp',
      hp.toMap(),
      where: 'id = ?',
      whereArgs: [hp.id],
    );
  }

  Future<int> deleteHp(int id) async {
    final db = await database;
    return await db.delete(
      'hp',
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
