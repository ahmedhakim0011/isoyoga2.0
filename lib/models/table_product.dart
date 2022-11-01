import 'package:sqflite/sqflite.dart';

import '../constants.dart';
import '../main.dart';

class ProductTable {
  ProductTable({
    this.id,
    this.productId,
    this.categoryId,
    this.productName,
    this.price,
    this.qty,
    this.Image,
    this.size,

  });

   int? id;
   String? productId;
   String? categoryId;
   String? productName;
   String? price;
   String? qty;
   String? Image;
   String? size;


  Future<void> insertProduct(ProductTable product) async {
    await db.insert(
      productTableName,
      product.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> updateProduct(ProductTable product) async {
    await db.update(
      productTableName,
      product.toMap(),
      where: 'id = ?',
      whereArgs: [product.id],
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteProduct(int productId) async {
    await db.delete(
      productTableName,
      where: 'productId = ?',
      whereArgs: [productId],
    );
  }

  Future<void> deleteAllProducts() async {
    await db.delete(
      productTableName,
      where: '1=1'
    );
  }

  Future<List<ProductTable>> fetchProducts() async {

    final maps = await db.query(
        productTableName); //query all the rows in a table as an array of maps

    return List.generate(maps.length, (i) {
      //create a list of Categories
      return ProductTable(
        id : maps[i]['id'] as int,
        productId: maps[i]['productId'] as String,
        categoryId: maps[i]['categoryId']== null ? "" : maps[i]['categoryId'] as String,
        productName: maps[i]['productName'] as String,
        price: maps[i]['price'] as String,
        qty: maps[i]['qty'] as String,
        Image: maps[i]['Image'] as String,
      );
    });
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'productId': productId,
      'categoryId': categoryId,
      'productName': productName,
      'qty': qty,
      'price': price,
      'Image': Image,
      'Size': size,


    };
  }
}
