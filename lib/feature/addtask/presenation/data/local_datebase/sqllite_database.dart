import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _databaseName = "todo.db";
  static final _databaseVersion = 1;
  static final table = 'taskTable';

  static final columnId = 'id';
  static final columnName = 'name';
  static final columnDescription = 'description';
  static final columnCompleted = 'completed';

  static Database? _database;

  Future<Database?> get database async {
    if (_database != null) return _database;
    _database = await _initDatabase();
    return _database;
  }

  _initDatabase() async {
    String path = join(await getDatabasesPath(), _databaseName);
    return await openDatabase(path,
        version: _databaseVersion, onCreate: _onCreate);
  }

  Future _onCreate(Database db, int version) async {
    await db.execute('''
      CREATE TABLE $table (
        $columnId INTEGER PRIMARY KEY AUTOINCREMENT,
        $columnName TEXT NOT NULL,
        $columnDescription TEXT NOT NULL,
        $columnCompleted INTEGER NOT NULL
      )
    ''');
  }

  // Insert a task
  Future<int> insertTask(Map<String, dynamic> row) async {
    Database? db = await database;
    return await db!.insert(table, row);
  }

  // Get all tasks
  Future<List<Map<String, dynamic>>> queryAllTasks() async {
    Database? db = await database;
    return await db!.query(table);
  }

  // Update task
  Future<int> updateTask(Map<String, dynamic> row) async {
    Database? db = await database;
    int id = row[columnId];
    return await db!
        .update(table, row, where: '$columnId = ?', whereArgs: [id]);
  }

  // Delete task
  Future<int> deleteTask(int id) async {
    Database? db = await database;
    return await db!.delete(table, where: '$columnId = ?', whereArgs: [id]);
  }
}
