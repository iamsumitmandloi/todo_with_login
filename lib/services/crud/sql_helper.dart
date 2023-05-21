import 'package:flutter/foundation.dart';
import 'package:sqflite/sqflite.dart' as sql;

class SQLHelper {
  static Future<void> createTables(sql.Database database) async {
    await database.execute("""CREATE TABLE tasks(
        id INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,
        title TEXT,
        description TEXT,
        uid TEXT,
        createdAt TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
      )
      """);
  }
// id: the id of a item
// title, description: name and description of your activity
// created_at: the time that the item was created. It will be automatically handled by SQLite

  static Future<sql.Database> db() async {
    return sql.openDatabase(
      'kindacode.db',
      version: 1,
      onCreate: (sql.Database database, int version) async {
        await createTables(database);
      },
    );
  }

  // Create new task
  static Future<int> createTask(
      String title, String? descrption, String? uid) async {
    final db = await SQLHelper.db();

    final data = {'title': title, 'description': descrption, 'uid': uid};
    final id = await db.insert('tasks', data,
        conflictAlgorithm: sql.ConflictAlgorithm.replace);
    return id;
  }

  // Read all tasks
  static Future<List<Map<String, dynamic>>> getTasks(String? uid) async {
    final db = await SQLHelper.db();
    return db.query('tasks', where: "uid = ?", whereArgs: [uid], orderBy: "id");
  }

  // Update an item by id
  static Future<int> updateTask(
      int id, String title, String? descrption, String? uid) async {
    final db = await SQLHelper.db();

    final data = {
      'title': title,
      'description': descrption,
      'uid': uid,
      'createdAt': DateTime.now().toString()
    };

    final result =
        await db.update('tasks', data, where: "id = ?", whereArgs: [id]);
    return result;
  }

  // Delete
  static Future<void> deleteTask(int id) async {
    final db = await SQLHelper.db();
    try {
      await db.delete("tasks", where: "id = ?", whereArgs: [id]);
    } catch (err) {
      debugPrint("Something went wrong when deleting a task: $err");
    }
  }
}
