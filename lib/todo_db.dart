import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:todoapp/todo_model.dart';

class TodoDatabase {
  static final TodoDatabase instance = TodoDatabase._init();

  static Database? _database;
  TodoDatabase._init();

  Future<Database?> get database async {
    if (_database != null) return _database;

    _database = await _initDB('products.db');

    return _database;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const typeString = 'STRING NOT NULL';

    await db.execute('''
      CREATE TABLE $tableProducts(
        ${TodoFields.id} $idType,
        ${TodoFields.name} $typeString
      );
    ''');
  }

  Future<TodoModel> create(TodoModel product) async {
    final db = await instance.database;
    final json = product.toJson();
    const columns = '${TodoFields.id}, ${TodoFields.name}';
    final values = '${json[TodoFields.id]},"${json[TodoFields.name]}"';
    final id = await db!.rawInsert('INSERT INTO $tableProducts ($columns) VALUES ($values)');

    // final id = await db?.insert(tableProducts, product.toJson());
    return product.copy(id: id);
  }

  Future<TodoModel> readProduct(int id) async {
    final db = await instance.database;
    final maps = await db!.query(
      tableProducts,
      columns: TodoFields.values,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return TodoModel.fromJson(maps.first);
    } else {
      throw Exception('Not found');
    }
  }

  Future<List<TodoModel>> readAllProduct() async {
    final db = await instance.database;
    // final orderBy = '`${TodoFields.id}` ASC';
    final result = await db!.rawQuery('SELECT * FROM $tableProducts');
    return result.map((e) => TodoModel.fromJson(e)).toList();
  }

  Future<int> update(TodoModel product) async {
    final db = await instance.database;

    return db!.update(
      tableProducts,
      product.toJson(),
      where: '${TodoFields.id} = ?',
      whereArgs: [product.id],
    );
  }

  Future<int> delete(int id) async {
    final db = await instance.database;

    return await db!.delete(
      tableProducts,
      where: '${TodoFields.id} = ?',
      whereArgs: [id],
    );
  }

  Future<void> deleteAll() async {
    final db = await instance.database;

    await db!.rawQuery('DELETE FROM $tableProducts');
  }

  Future close() async {
    final db = await instance.database;
    db!.close();
  }
}
