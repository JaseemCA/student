import "package:sqflite/sqflite.dart";
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class DatabaseHelper {
  Database? _database;
  Future<Database?> setDatabase() async {
    var directory = await getApplicationDocumentsDirectory();
    var path = join(directory.path, 'db_curd');
    _database = await openDatabase(
      path,
      version: 2,
      onCreate: createDatabase,
      onUpgrade: (db, oldVersion, newVersion) {
        if (oldVersion < 2) {
          db.execute('ALTER TABLE students ADD COLUMN address TEXT');
        }
      },
    );
    return _database;
  }

  Future<void> createDatabase(database, version) async {
    String sql =
        "CREATE TABLE students(id INTEGER PRIMARY KEY,name TEXT,clas TEXT,age TEXT,Roll TEXT,selectedImage TEXT,address TEXT );";
    await database.execute(sql);
  }

  getDatabase() async {
    if (_database == null) {
      await setDatabase();
      return _database;
    } else {
      return _database;
    }
  }

  insertData(table, data) async {
    var connection = await getDatabase();
    return await connection?.insert(table, data);
  }

  updateData(table, data) async {
    var connection = await getDatabase();
    return await connection
        ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
  }

// //delete student

  deleteDataById(table, itemId) async {
    var connection = await getDatabase();

    return await connection?.rawDelete("delete from $table where id=$itemId");
  }

  //Readalldata
  readAllUsers() async {
    var connection = await getDatabase();
    return await connection?.query('students');
  }

//singleTon
  DatabaseHelper._();
  static DatabaseHelper _instance = DatabaseHelper._();
  static DatabaseHelper get instance => _instance;

  // satatic deleteUser(userId) {}
}
