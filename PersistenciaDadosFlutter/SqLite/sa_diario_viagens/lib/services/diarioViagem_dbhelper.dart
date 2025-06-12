import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/viagem_model.dart';
import '../models/entrada_diaria_model.dart';

class DiarioViagemDBHelper {

  static Database? _database;

  static final DiarioViagemDBHelper _instance = DiarioViagemDBHelper._internal();

  DiarioViagemDBHelper._internal();
  factory DiarioViagemDBHelper(){
    return _instance;
  }

  Future<Database> _initDatabase() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, "diario_viagens.db");
    return await openDatabase(path, version: 1, onCreate: _onCreateDB);
  }

  Future _onCreateDB(Database db, int version) async {
    await db.execute("""
      CREATE TABLE IF NOT EXISTS viagens(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        titulo TEXT NOT NULL,
        destino TEXT NOT NULL,
        data_inicio TEXT NOT NULL,
        data_fim TEXT NOT NULL,
        descricao TEXT NOT NULL
      )
    """);
    await db.execute("""
      CREATE TABLE IF NOT EXISTS entradas_diarias(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        viagem_id INTEGER NOT NULL,
        data TEXT NOT NULL,
        texto TEXT NOT NULL,
        foto_path TEXT,
        FOREIGN KEY (viagem_id) REFERENCES viagens(id) ON DELETE CASCADE
      )
    """);
  }

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDatabase();
      return _database!;
    }
  }

  // CRUD Viagem
  Future<int> insertViagem(Viagem viagem) async {
    final db = await database;
    return db.insert("viagens", viagem.toMap());
  }

  Future<List<Viagem>> getViagens() async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("viagens");
    return maps.map((e) => Viagem.fromMap(e)).toList();
  }

  Future<Viagem?> getViagemById(int id) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "viagens",
      where: "id = ?",
      whereArgs: [id],
    );
    if (maps.isEmpty) {
      return null;
    } else{
      return Viagem.fromMap(maps.first);
    }
    
  }

  Future<int> deleteViagem(int id) async {
    final db = await database;
    return db.delete("viagens", where: "id=?", whereArgs: [id]);
  }

  Future<int> insertEntrada(EntradaDiaria entrada) async {
    final db = await database;
    return db.insert("entradas_diarias", entrada.toMap());
  }

  Future<List<EntradaDiaria>> getEntradasForViagem(int viagemId) async {
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query(
      "entradas_diarias",
      where: "viagem_id = ?",
      whereArgs: [viagemId],
    );
    return maps.map((e) => EntradaDiaria.fromMap(e)).toList();
  }

  Future<int> deleteEntrada(int id) async {
    final db = await database;
    return db.delete("entradas_diarias", where: "id=?", whereArgs: [id]);
  }
}