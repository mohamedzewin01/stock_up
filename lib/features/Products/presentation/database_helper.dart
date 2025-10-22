import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_up/features/Products/data/models/response/get_all_products_model.dart';

class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('products.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'TEXT PRIMARY KEY';
    const textType = 'TEXT';
    const intType = 'INTEGER';

    await db.execute('''
      CREATE TABLE products (
        product_id $idType,
        product_number $textType,
        product_name $textType,
        total_quantity $textType,
        unit $textType,
        selling_price $textType,
        average_purchase_price $textType,
        last_purchase_price $textType,
        category_id $textType,
        category_name $textType,
        taxable $textType,
        tax_rate $textType,
        barcodes $textType
      )
    ''');

    await db.execute('''
      CREATE TABLE store_info (
        id $idType,
        name $textType
      )
    ''');
  }

  // حفظ المنتجات في قاعدة البيانات
  Future<void> insertProducts(List<Results> products) async {
    final db = await database;

    // حذف البيانات القديمة
    await db.delete('products');

    // إدراج البيانات الجديدة
    final batch = db.batch();
    for (var product in products) {
      batch.insert('products', {
        'product_id': product.productId,
        'product_number': product.productNumber,
        'product_name': product.productName,
        'total_quantity': product.totalQuantity,
        'unit': product.unit,
        'selling_price': product.sellingPrice,
        'average_purchase_price': product.averagePurchasePrice,
        'last_purchase_price': product.lastPurchasePrice,
        'category_id': product.categoryId,
        'category_name': product.categoryName,
        'taxable': product.taxable,
        'tax_rate': product.taxRate,
        'barcodes': product.barcodes?.join(',') ?? '',
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit(noResult: true);
  }

  // حفظ معلومات المتجر
  Future<void> insertStoreInfo(Store store) async {
    final db = await database;
    await db.delete('store_info');
    await db.insert('store_info', {
      'id': store.id,
      'name': store.name,
    }, conflictAlgorithm: ConflictAlgorithm.replace);
  }

  // استرجاع جميع المنتجات
  Future<List<Results>> getAllProducts() async {
    final db = await database;
    final result = await db.query('products');

    return result.map((json) {
      return Results(
        productId: json['product_id'] as String?,
        productNumber: json['product_number'] as String?,
        productName: json['product_name'] as String?,
        totalQuantity: json['total_quantity'] as String?,
        unit: json['unit'] as String?,
        sellingPrice: json['selling_price'] as String?,
        averagePurchasePrice: json['average_purchase_price'] as String?,
        lastPurchasePrice: json['last_purchase_price'] as String?,
        categoryId: json['category_id'] as String?,
        categoryName: json['category_name'] as String?,
        taxable: json['taxable'] as String?,
        taxRate: json['tax_rate'] as String?,
        barcodes: (json['barcodes'] as String).isNotEmpty
            ? (json['barcodes'] as String).split(',')
            : null,
      );
    }).toList();
  }

  // البحث عن منتج بالاسم أو الباركود
  Future<List<Results>> searchProducts(String query) async {
    final db = await database;
    final result = await db.query(
      'products',
      where: 'product_name LIKE ? OR product_number LIKE ? OR barcodes LIKE ?',
      whereArgs: ['%$query%', '%$query%', '%$query%'],
    );

    return result.map((json) {
      return Results(
        productId: json['product_id'] as String?,
        productNumber: json['product_number'] as String?,
        productName: json['product_name'] as String?,
        totalQuantity: json['total_quantity'] as String?,
        unit: json['unit'] as String?,
        sellingPrice: json['selling_price'] as String?,
        averagePurchasePrice: json['average_purchase_price'] as String?,
        lastPurchasePrice: json['last_purchase_price'] as String?,
        categoryId: json['category_id'] as String?,
        categoryName: json['category_name'] as String?,
        taxable: json['taxable'] as String?,
        taxRate: json['tax_rate'] as String?,
        barcodes: (json['barcodes'] as String).isNotEmpty
            ? (json['barcodes'] as String).split(',')
            : null,
      );
    }).toList();
  }

  // استرجاع معلومات المتجر
  Future<Store?> getStoreInfo() async {
    final db = await database;
    final result = await db.query('store_info', limit: 1);

    if (result.isEmpty) return null;

    final json = result.first;
    return Store(id: json['id'] as String?, name: json['name'] as String?);
  }

  // التحقق من وجود بيانات
  Future<bool> hasProducts() async {
    final db = await database;
    final result = await db.query('products', limit: 1);
    return result.isNotEmpty;
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
