// import 'package:injectable/injectable.dart';
// import 'package:path/path.dart';
// import 'package:sqflite/sqflite.dart';
// import 'package:stock_up/features/Products/data/models/response/get_all_products_model.dart';
//
// @lazySingleton
// class DatabaseHelper {
//   static final DatabaseHelper instance = DatabaseHelper._init();
//   static Database? _database;
//
//   DatabaseHelper._init();
//
//   @factoryMethod
//   static DatabaseHelper create() => DatabaseHelper._init();
//
//   Future<Database> get database async {
//     if (_database != null) return _database!;
//     _database = await _initDB('products.db');
//     return _database!;
//   }
//
//   Future<Database> _initDB(String filePath) async {
//     final dbPath = await getDatabasesPath();
//     final path = join(dbPath, filePath);
//
//     return await openDatabase(path, version: 1, onCreate: _createDB);
//   }
//
//   Future _createDB(Database db, int version) async {
//     const idType = 'TEXT PRIMARY KEY';
//     const textType = 'TEXT';
//
//     await db.execute('''
//       CREATE TABLE products (
//         product_id $idType,
//         product_number $textType,
//         product_name $textType,
//         total_quantity $textType,
//         unit $textType,
//         selling_price $textType,
//         average_purchase_price $textType,
//         last_purchase_price $textType,
//         category_id $textType,
//         category_name $textType,
//         taxable $textType,
//         tax_rate $textType,
//         barcodes $textType
//       )
//     ''');
//
//     await db.execute('''
//       CREATE TABLE store_info (
//         id $idType,
//         name $textType
//       )
//     ''');
//
//     // إضافة indexes لتحسين سرعة البحث
//     await db.execute('''
//       CREATE INDEX idx_product_name ON products(product_name)
//     ''');
//
//     await db.execute('''
//       CREATE INDEX idx_product_number ON products(product_number)
//     ''');
//
//     print('✅ تم إنشاء قاعدة البيانات مع الـ indexes');
//   }
//
//   // دالة مساعدة لتحويل القيم إلى String بأمان
//   String? _toStringOrNull(dynamic value) {
//     if (value == null) return null;
//     if (value is String) return value;
//     return value.toString();
//   }
//
//   // حفظ المنتجات في قاعدة البيانات (الطريقة القديمة)
//   Future<void> insertProducts(List<Results> products) async {
//     final db = await database;
//
//     // حذف البيانات القديمة
//     await db.delete('products');
//
//     print('💾 حفظ ${products.length} منتج...');
//
//     // إدراج البيانات الجديدة
//     final batch = db.batch();
//     for (var product in products) {
//       batch.insert('products', {
//         'product_id': _toStringOrNull(product.productId),
//         'product_number': _toStringOrNull(product.productNumber),
//         'product_name': _toStringOrNull(product.productName),
//         'total_quantity': _toStringOrNull(product.totalQuantity),
//         'unit': _toStringOrNull(product.unit),
//         'selling_price': _toStringOrNull(product.sellingPrice),
//         'average_purchase_price': _toStringOrNull(product.averagePurchasePrice),
//         'last_purchase_price': _toStringOrNull(product.lastPurchasePrice),
//         'category_id': _toStringOrNull(product.categoryId),
//         'category_name': _toStringOrNull(product.categoryName),
//         'taxable': _toStringOrNull(product.taxable),
//         'tax_rate': _toStringOrNull(product.taxRate),
//         'barcodes': product.barcodes?.join(',') ?? '',
//       }, conflictAlgorithm: ConflictAlgorithm.replace);
//     }
//     await batch.commit(noResult: true);
//
//     print('✅ تم حفظ ${products.length} منتج بنجاح');
//   }
//
//   // حفظ المنتجات على دفعات (أسرع للكميات الكبيرة)
//   Future<void> insertProductsBatch(List<Results> products) async {
//     final db = await database;
//
//     // إذا كانت هذه أول دفعة، نحذف البيانات القديمة
//     final count = await db.rawQuery('SELECT COUNT(*) as count FROM products');
//     final currentCount = Sqflite.firstIntValue(count) ?? 0;
//
//     if (currentCount == 0) {
//       await db.delete('products');
//     }
//
//     // استخدام transaction لتحسين الأداء
//     await db.transaction((txn) async {
//       final batch = txn.batch();
//
//       for (var product in products) {
//         batch.insert('products', {
//           'product_id': _toStringOrNull(product.productId),
//           'product_number': _toStringOrNull(product.productNumber),
//           'product_name': _toStringOrNull(product.productName),
//           'total_quantity': _toStringOrNull(product.totalQuantity),
//           'unit': _toStringOrNull(product.unit),
//           'selling_price': _toStringOrNull(product.sellingPrice),
//           'average_purchase_price': _toStringOrNull(
//             product.averagePurchasePrice,
//           ),
//           'last_purchase_price': _toStringOrNull(product.lastPurchasePrice),
//           'category_id': _toStringOrNull(product.categoryId),
//           'category_name': _toStringOrNull(product.categoryName),
//           'taxable': _toStringOrNull(product.taxable),
//           'tax_rate': _toStringOrNull(product.taxRate),
//           'barcodes': product.barcodes?.join(',') ?? '',
//         }, conflictAlgorithm: ConflictAlgorithm.replace);
//       }
//
//       await batch.commit(noResult: true);
//     });
//   }
//
//   // حفظ معلومات المتجر
//   Future<void> insertStoreInfo(Store store) async {
//     final db = await database;
//     await db.delete('store_info');
//     await db.insert('store_info', {
//       'id': _toStringOrNull(store.id),
//       'name': _toStringOrNull(store.name),
//     }, conflictAlgorithm: ConflictAlgorithm.replace);
//   }
//
//   // استرجاع جميع المنتجات
//   Future<List<Results>> getAllProducts() async {
//     final db = await database;
//     final result = await db.query('products');
//
//     return result.map((json) {
//       return Results(
//         productId: json['product_id'] as String?,
//         productNumber: json['product_number'] as String?,
//         productName: json['product_name'] as String?,
//         totalQuantity: json['total_quantity'] as String?,
//         unit: json['unit'] as String?,
//         sellingPrice: json['selling_price'] as String?,
//         averagePurchasePrice: json['average_purchase_price'] as String?,
//         lastPurchasePrice: json['last_purchase_price'] as String?,
//         categoryId: json['category_id'] as String?,
//         categoryName: json['category_name'] as String?,
//         taxable: json['taxable'] as String?,
//         taxRate: json['tax_rate'] as String?,
//         barcodes: (json['barcodes'] as String?)?.isNotEmpty == true
//             ? (json['barcodes'] as String).split(',')
//             : null,
//       );
//     }).toList();
//   }
//
//   // البحث عن منتج بالاسم أو الباركود
//   Future<List<Results>> searchProducts(String query) async {
//     final db = await database;
//     final result = await db.query(
//       'products',
//       where: 'product_name LIKE ? OR product_number LIKE ? OR barcodes LIKE ?',
//       whereArgs: ['%$query%', '%$query%', '%$query%'],
//     );
//
//     return result.map((json) {
//       return Results(
//         productId: json['product_id'] as String?,
//         productNumber: json['product_number'] as String?,
//         productName: json['product_name'] as String?,
//         totalQuantity: json['total_quantity'] as String?,
//         unit: json['unit'] as String?,
//         sellingPrice: json['selling_price'] as String?,
//         averagePurchasePrice: json['average_purchase_price'] as String?,
//         lastPurchasePrice: json['last_purchase_price'] as String?,
//         categoryId: json['category_id'] as String?,
//         categoryName: json['category_name'] as String?,
//         taxable: json['taxable'] as String?,
//         taxRate: json['tax_rate'] as String?,
//         barcodes: (json['barcodes'] as String?)?.isNotEmpty == true
//             ? (json['barcodes'] as String).split(',')
//             : null,
//       );
//     }).toList();
//   }
//
//   // استرجاع معلومات المتجر
//   Future<Store?> getStoreInfo() async {
//     final db = await database;
//     final result = await db.query('store_info', limit: 1);
//
//     if (result.isEmpty) return null;
//
//     final json = result.first;
//     return Store(id: json['id'] as String?, name: json['name'] as String?);
//   }
//
//   // التحقق من وجود بيانات
//   Future<bool> hasProducts() async {
//     final db = await database;
//     final result = await db.query('products', limit: 1);
//     return result.isNotEmpty;
//   }
//
//   Future close() async {
//     final db = await database;
//     db.close();
//   }
// }
import 'package:injectable/injectable.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:stock_up/features/Products/data/models/response/get_all_products_model.dart';

@lazySingleton
class DatabaseHelper {
  static final DatabaseHelper instance = DatabaseHelper._init();
  static Database? _database;

  DatabaseHelper._init();

  @factoryMethod
  static DatabaseHelper create() => DatabaseHelper._init();

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

    // إضافة indexes لتحسين سرعة البحث
    await db.execute('''
      CREATE INDEX idx_product_name ON products(product_name)
    ''');

    await db.execute('''
      CREATE INDEX idx_product_number ON products(product_number)
    ''');

    print('✅ تم إنشاء قاعدة البيانات مع الـ indexes');
  }

  // دالة مساعدة محسّنة لتحويل القيم إلى String بأمان (تعالج int و double)
  String? _toStringOrNull(dynamic value) {
    if (value == null) return null;
    if (value is String) return value;
    if (value is int) return value.toString();
    if (value is double) return value.toString();
    if (value is num) return value.toString();
    return value.toString();
  }

  // دالة لتحويل Results إلى Map بأمان
  Map<String, dynamic> _productToMap(Results product) {
    try {
      return {
        'product_id': _toStringOrNull(product.productId),
        'product_number': _toStringOrNull(product.productNumber),
        'product_name': _toStringOrNull(product.productName),
        'total_quantity': _toStringOrNull(product.totalQuantity),
        'unit': _toStringOrNull(product.unit),
        'selling_price': _toStringOrNull(product.sellingPrice),
        'average_purchase_price': _toStringOrNull(product.averagePurchasePrice),
        'last_purchase_price': _toStringOrNull(product.lastPurchasePrice),
        'category_id': _toStringOrNull(product.categoryId),
        'category_name': _toStringOrNull(product.categoryName),
        'taxable': _toStringOrNull(product.taxable),
        'tax_rate': _toStringOrNull(product.taxRate),
        'barcodes': product.barcodes?.join(',') ?? '',
      };
    } catch (e) {
      print('⚠️ خطأ في تحويل المنتج: ${product.productId} - $e');
      // إرجاع قيم افتراضية في حالة الخطأ
      return {
        'product_id': product.productId?.toString() ?? '',
        'product_number': product.productNumber?.toString() ?? '',
        'product_name': product.productName?.toString() ?? 'Unknown',
        'total_quantity': '0',
        'unit': '',
        'selling_price': '0',
        'average_purchase_price': '0',
        'last_purchase_price': '0',
        'category_id': '',
        'category_name': '',
        'taxable': '0',
        'tax_rate': '0',
        'barcodes': '',
      };
    }
  }

  // حفظ المنتجات في قاعدة البيانات (الطريقة القديمة)
  Future<void> insertProducts(List<Results> products) async {
    if (products.isEmpty) return;

    final db = await database;

    try {
      // حذف البيانات القديمة
      await db.delete('products');

      print('💾 بدء حفظ ${products.length} منتج...');

      // إدراج البيانات الجديدة
      final batch = db.batch();
      int successCount = 0;
      int errorCount = 0;

      for (var product in products) {
        try {
          final productMap = _productToMap(product);
          batch.insert(
            'products',
            productMap,
            conflictAlgorithm: ConflictAlgorithm.replace,
          );
          successCount++;
        } catch (e) {
          errorCount++;
          print('⚠️ خطأ في منتج: ${product.productId} - $e');
        }
      }

      await batch.commit(noResult: true);

      print('✅ تم حفظ $successCount منتج بنجاح');
      if (errorCount > 0) {
        print('⚠️ فشل حفظ $errorCount منتج');
      }
    } catch (e) {
      print('❌ خطأ عام في insertProducts: $e');
      rethrow;
    }
  }

  // حفظ المنتجات على دفعات (أسرع للكميات الكبيرة)
  Future<void> insertProductsBatch(List<Results> products) async {
    if (products.isEmpty) return;

    final db = await database;

    try {
      // إذا كانت هذه أول دفعة، نحذف البيانات القديمة
      final count = await db.rawQuery('SELECT COUNT(*) as count FROM products');
      final currentCount = Sqflite.firstIntValue(count) ?? 0;

      if (currentCount == 0) {
        await db.delete('products');
      }

      // استخدام transaction لتحسين الأداء
      await db.transaction((txn) async {
        final batch = txn.batch();
        int successCount = 0;
        int errorCount = 0;

        for (var product in products) {
          try {
            final productMap = _productToMap(product);
            batch.insert(
              'products',
              productMap,
              conflictAlgorithm: ConflictAlgorithm.replace,
            );
            successCount++;
          } catch (e) {
            errorCount++;
            // طباعة فقط أول 5 أخطاء لتجنب الازدحام
            if (errorCount <= 5) {
              print('⚠️ خطأ في منتج: ${product.productId} - $e');
            }
          }
        }

        await batch.commit(noResult: true);

        if (errorCount > 5) {
          print('⚠️ وأخطاء أخرى (${errorCount - 5})...');
        }
      });
    } catch (e) {
      print('❌ خطأ عام في insertProductsBatch: $e');
      rethrow;
    }
  }

  // حفظ معلومات المتجر
  Future<void> insertStoreInfo(Store store) async {
    try {
      final db = await database;
      await db.delete('store_info');
      await db.insert('store_info', {
        'id': _toStringOrNull(store.id),
        'name': _toStringOrNull(store.name),
      }, conflictAlgorithm: ConflictAlgorithm.replace);
    } catch (e) {
      print('❌ خطأ في insertStoreInfo: $e');
      rethrow;
    }
  }

  // استرجاع جميع المنتجات
  Future<List<Results>> getAllProducts() async {
    try {
      final db = await database;
      final result = await db.query('products');

      return result.map((json) {
        try {
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
            barcodes: (json['barcodes'] as String?)?.isNotEmpty == true
                ? (json['barcodes'] as String).split(',')
                : null,
          );
        } catch (e) {
          print('⚠️ خطأ في قراءة منتج: ${json['product_id']} - $e');
          // إرجاع منتج بقيم افتراضية
          return Results(
            productId: json['product_id']?.toString(),
            productName: json['product_name']?.toString() ?? 'Unknown',
          );
        }
      }).toList();
    } catch (e) {
      print('❌ خطأ في getAllProducts: $e');
      rethrow;
    }
  }

  // البحث عن منتج بالاسم أو الباركود
  Future<List<Results>> searchProducts(String query) async {
    try {
      final db = await database;
      final result = await db.query(
        'products',
        where:
            'product_name LIKE ? OR product_number LIKE ? OR barcodes LIKE ?',
        whereArgs: ['%$query%', '%$query%', '%$query%'],
      );

      return result.map((json) {
        try {
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
            barcodes: (json['barcodes'] as String?)?.isNotEmpty == true
                ? (json['barcodes'] as String).split(',')
                : null,
          );
        } catch (e) {
          print('⚠️ خطأ في قراءة نتيجة بحث: ${json['product_id']} - $e');
          return Results(
            productId: json['product_id']?.toString(),
            productName: json['product_name']?.toString() ?? 'Unknown',
          );
        }
      }).toList();
    } catch (e) {
      print('❌ خطأ في searchProducts: $e');
      rethrow;
    }
  }

  // استرجاع معلومات المتجر
  Future<Store?> getStoreInfo() async {
    try {
      final db = await database;
      final result = await db.query('store_info', limit: 1);

      if (result.isEmpty) return null;

      final json = result.first;
      return Store(id: json['id'] as String?, name: json['name'] as String?);
    } catch (e) {
      print('❌ خطأ في getStoreInfo: $e');
      return null;
    }
  }

  // التحقق من وجود بيانات
  Future<bool> hasProducts() async {
    try {
      final db = await database;
      final result = await db.query('products', limit: 1);
      return result.isNotEmpty;
    } catch (e) {
      print('❌ خطأ في hasProducts: $e');
      return false;
    }
  }

  Future close() async {
    final db = await database;
    db.close();
  }
}
