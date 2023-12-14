// import 'package:sqflite/sqflite.dart';
// import 'package:student/db_helper/database_connection.dart';

// class Repository {
//   late DatabaseConnection databaseConnection;
//   Repository() {
//     databaseConnection = DatabaseConnection(); //instance
//   }
//   static Database? databasee;
//   Future<Database?> get database async {
//     if (databasee != null) {
//       return databasee;
//     } else {
//       databasee = await databaseConnection.setDatabase();
//       return databasee;
//     }
//   }

// //insertstudent
//   insertData(table, data) async {
//     var connection = await database;
//     print(connection);
//     return await connection?.insert(table, data);
//   }

// //Read all record
//   readData(table) async {
//     var connection = await database;
//     return await connection?.query(table);
//   }

// //read single record by id
//   readDataById(table, itemId) async {
//     var connection = await database;
//     return await connection?.query(table, where: 'id=?', whereArgs: [itemId]);
//   }

// //update student
//   updateData(table, data) async {
//     var connection = await database;
//     return await connection
//         ?.update(table, data, where: 'id=?', whereArgs: [data['id']]);
//   }

// //delete student
//   deleteDataById(table, itemId) async {
//     var connection = await database;
//     return await connection?.rawDelete("delete from $table where id=$itemId");
//   }
// }
