import 'package:sa_petshop/models/pet_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class PetShopDBHelper{ //fazer conecão singleton
  static Database? _database;
  static final PetShopDBHelper _instance = PetShopDBHelper._internal();

  PetShopDBHelper._internal();
  factory PetShopDBHelper() {
    return _instance;
  }
  // verificação do banco de dados -> verifica se o banco já foi criado e se esta aberto
  Future<Database> _initDatabase() async{
    final dbPath = await getDatabasePath();
    final path = join(dbPath, 'petshop.db');

    return await openDatabase(
      path,
      onCreate: (db,version) async{
        await db.execute(
          '''CREATE TABLE IF NOT EXISTS pets (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            nome TEXT NOT NULL,
            raca TEXT NOT NULL,
            nome_dono TEXT NOT NULL,
            telefone_dono TEXT NOT NULL,
            );'''
        );
      },
      version: 1,
    );
  }

  Future<DataBase> get database async {
    if(_database != null) {return _database!;}
  else{
    _database = await _initDatabase();
    return _database!;
    }
  }

  Future<int> insertPet(Pet pet) async{
    final db = await database;
    return db.insert("pets", pet.toMap());
  }
  Future<List<Pet>> getPets() async{
    final db = await database;
    final List<Map<String, dynamic>> maps = await db.query("pets");
    return maps.map((e) => Pet.fromMap(e)).toList();
  }
  Future<Pet?> getPetById(int id) async{
    final db = await database;
    final List<Map<String,dynamic>> maps = await db.query("pets", where: "id = ?", whereArgs: [id]);
    if (maps.isEmpty) {
      return null;
    }else{
      Pet.fromMap(maps.first);
    }
  }

  Future<int> deletePet(int id) async{
    final db = await database;
    return await db.delete("pets", where: "id = ?", whereArgs: [id]);
  }
}