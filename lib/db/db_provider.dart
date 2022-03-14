import 'package:flutter_application_works/model/task_model.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DBProvider {
  DBProvider._();

  static final DBProvider dataBase = DBProvider._();
  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    _database = await initDataBase();
    return _database!;
  }

  initDataBase() async {
    return await openDatabase(
      join(await getDatabasesPath(), 'todo_app_db.db'),
      onCreate: (db, version) async {
        await db.execute('''
        CREATE TABLE tasks (id INTEGER PRIMARY KEY AUTOINCREMENT, task TEXT, creationDate TEXT)
        ''');
      },
      version: 1,
    );
  }

  addNewTask(Task newTask) async {
    final db = await database;
    db.insert(
      'tasks',
      newTask.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<dynamic>> getTask() async {
    final db = await database;
    var result = await db.query('tasks');
    if (result.isEmpty) {
      return [];
    } else {
      var resultMap = result.toList();
      return resultMap.isNotEmpty ? resultMap : [];
    }
  }

  deleteTask(int id) async {
    final db = await database;
    db.delete('tasks', where: 'id = ?', whereArgs: [id]);
  }
}
