// import "package:sqflite/sqflite.dart";
// import 'package:path/path.dart';
// import 'package:path_provider/path_provider.dart';

// class DatabaseConnection {
//   Future<Database> setDatabase() async {
//     var directory = await getApplicationDocumentsDirectory();
//     var path = join(directory.path, 'db_curd');
//     var database =
//         await openDatabase(path, version: 1, onCreate: createDatabase);
//     return database;
//   }

//   Future<void> createDatabase(Database database, int version) async {
//     String sql =
//         "CREATE TABLE students(id INTEGER PRIMARY KEY,name TEXT,clas TEXT,age TEXT,Roll TEXT);";
//     await database.execute(sql);
//   }
// }
