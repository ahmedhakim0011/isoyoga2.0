import 'dart:io';
import 'dart:async';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../constants.dart';

class DbProvider {
  final String productTableName = "PRODUCTS";

  static late Database _db;

  // Factory constructor
  factory DbProvider() {
    return DbProvider._();
  }

  // Generative constructor
  DbProvider._();

  Database getDB() {
    return _db;
  }

  Future<void> init() async {
    Directory directory =
        await getApplicationDocumentsDirectory(); //returns a directory which stores permanent files
    final path = join(directory.path, databaseName); //create path to database

    _db = await openDatabase(
      //open the database or create a database if there isn't any
      path,
      version: 1,
      onCreate: (Database db, int version) async {
        await db.execute(productTable);
      },
    );
  }

  static const productTable = """
          CREATE TABLE PRODUCTS (
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          productId TEXT,
          categoryId TEXT,
          productName TEXT,
          mapCode TEXT,
          price TEXT,
          qty TEXT,
          Image TEXT
          );""";

  // Future<int> addProduct(ModelProduct item) async {
  //   //returns number of items inserted as an integer
  //
  //   final db = await init(); //open database
  //
  //   return db.insert(
  //     productTableName, item.toMap(), //toMap() function from CategoryModel
  //     conflictAlgorithm:
  //         ConflictAlgorithm.ignore, //ignores conflicts due to duplicate entries
  //   );
  // }

  // Future<List<ModelProduct>> fetchProducts() async {
  //   //returns the Categories as a list (array)
  //
  //   final db = await init();
  //   final maps = await db.query(
  //       productTableName); //query all the rows in a table as an array of maps
  //
  //   return List.generate(maps.length, (i) {
  //     //create a list of Categories
  //     return ModelProduct(
  //       productId: maps[i]['productId'] as int,
  //       productSerial: maps[i]['productSerial'] as String,
  //       productName: maps[i]['productName'] as String,
  //       productExpiry: maps[i]['productExpiry'] as String,
  //       customerName: maps[i]['customerName'] as String,
  //       productCreatedAt: maps[i]['productCreatedAt'] as String,
  //       productUpdatedAt: maps[i]['productUpdatedAt'] as String,
  //     );
  //   });
  // }
  //
  // Future<List<ModelProduct>> fetchProductBySerial(String serial) async {
  //   //returns the Categories as a list (array)
  //
  //   final db = await init();
  //   final maps = await db.query(productTableName,
  //       where: "productSerial = ?",
  //       whereArgs: [
  //         serial
  //       ]); //query all the rows in a table as an array of maps
  //
  //   return List.generate(maps.length, (i) {
  //     //create a list of Categories
  //     return ModelProduct(
  //       productId: maps[i]['productId'] as int,
  //       productSerial: maps[i]['productSerial'] as String,
  //       productName: maps[i]['productName'] as String,
  //       productExpiry: maps[i]['productExpiry'] as String,
  //       customerName: maps[i]['customerName'] as String,
  //       productCreatedAt: maps[i]['productCreatedAt'] as String,
  //       productUpdatedAt: maps[i]['productUpdatedAt'] as String,
  //     );
  //   });
  // }

  // Future<int> deleteProduct(String id) async {
  //   //returns number of items deleted
  //   final db = await init();
  //
  //   int result = await db.delete(productTableName, //table name
  //       where: "productId = ?",
  //       whereArgs: [id] // use whereArgs to avoid SQL injection
  //       );
  //
  //   return result;
  // }
}
