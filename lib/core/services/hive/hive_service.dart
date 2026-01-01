import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constants.dart';
import 'package:lost_n_found/features/auth/data/models/auth_hive_model.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/category/data/models/category_hive_model.dart';

import 'package:path_provider/path_provider.dart';

final hiveServiceProvider = Provider<HiveService>((ref) {
  return HiveService();
});

class HiveService {
  // init
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstants.dbName}';
    Hive.init(path);

    // register adapter
    _registerAdapter();
    await _openBoxes();
    // insert dummy data
    await insertBatchDummyData();
    await insertCategoryDummyData();
  }

  Future<void> insertBatchDummyData() async {
    final batchBox = Hive.box<BatchHiveModel>(HiveTableConstants.batchTable);

    if (batchBox.isNotEmpty) {
      return;
    }

    final dummyBatches = [
      BatchHiveModel(batchName: '35A'),
      BatchHiveModel(batchName: '35B'),
      BatchHiveModel(batchName: '35C'),
      BatchHiveModel(batchName: '36A'),
      BatchHiveModel(batchName: '36B'),
      BatchHiveModel(batchName: '37A'),
      BatchHiveModel(batchName: '38B'),
    ];

    for (var batch in dummyBatches) {
      await batchBox.put(batch.batchId, batch);
    }
  }

  Future<void> insertCategoryDummyData() async {
    final categoryBox = Hive.box<CategoryHiveModel>(
      HiveTableConstants.categoryTable,
    );

    if (categoryBox.isNotEmpty) {
      return;
    }

    final dummyCategories = [
      CategoryHiveModel(
        categoryName: 'Electronics',
        description: 'Phones, laptops, tablets, etc.',
      ),
      CategoryHiveModel(
        categoryName: 'Personal',
        description: 'Personal belongings',
      ),
      CategoryHiveModel(
        categoryName: 'Accessories',
        description: 'Watches, jewelry, etc.',
      ),
      CategoryHiveModel(
        categoryName: 'Documents',
        description: 'IDs, certificates, papers',
      ),
      CategoryHiveModel(
        categoryName: 'Keys',
        description: 'House keys, car keys, etc.',
      ),
      CategoryHiveModel(
        categoryName: 'Bags',
        description: 'Backpacks, handbags, wallets',
      ),
      CategoryHiveModel(
        categoryName: 'Other',
        description: 'Miscellaneous items',
      ),
    ];

    for (var category in dummyCategories) {
      await categoryBox.put(category.categoryId, category);
    }
  }

  // Adapter register
  void _registerAdapter() {
    if (!Hive.isAdapterRegistered(HiveTableConstants.batchTypeId)) {
      Hive.registerAdapter(BatchHiveModelAdapter());
    }
    if (!Hive.isAdapterRegistered(HiveTableConstants.studentTypeId)) {
      Hive.registerAdapter(AuthHiveModelAdapter());
    }

    if (!Hive.isAdapterRegistered(HiveTableConstants.categoryTypeId)) {
      Hive.registerAdapter(CategoryHiveModelAdapter());
    }
  }

  // box open
  Future<void> _openBoxes() async {
    await Hive.openBox<BatchHiveModel>(HiveTableConstants.batchTable);
    await Hive.openBox<AuthHiveModel>(HiveTableConstants.studentTable);
    await Hive.openBox<CategoryHiveModel>(HiveTableConstants.categoryTable);
  }

  // box close
  Future<void> _close() async {
    await Hive.close();
  }

  // ======================= Batch Queries =========================

  Box<BatchHiveModel> get _batchBox =>
      Hive.box<BatchHiveModel>(HiveTableConstants.batchTable);

  Future<BatchHiveModel> createBatch(BatchHiveModel batch) async {
    await _batchBox.put(batch.batchId, batch);
    return batch;
  }

  List<BatchHiveModel> getAllBatches() {
    return _batchBox.values.toList();
  }

  BatchHiveModel? getBatchById(String batchId) {
    return _batchBox.get(batchId);
  }

  Future<bool> updateBatch(BatchHiveModel batch) async {
    if (_batchBox.containsKey(batch.batchId)) {
      await _batchBox.put(batch.batchId, batch);
      return true;
    }
    return false;
  }

  Future<void> deleteBatch(String batchId) async {
    await _batchBox.delete(batchId);
  }

  // ======================= Auth Queries =========================

  Box<AuthHiveModel> get _authBox =>
      Hive.box<AuthHiveModel>(HiveTableConstants.studentTable);

  // Register user
  Future<AuthHiveModel> register(AuthHiveModel user) async {
    await _authBox.put(user.authId, user);
    return user;
  }

  // Login - find user by email and password
  AuthHiveModel? login(String email, String password) {
    try {
      return _authBox.values.firstWhere(
        (user) => user.email == email && user.password == password,
      );
    } catch (e) {
      return null;
    }
  }

  // Get user by ID
  AuthHiveModel? getUserById(String authId) {
    return _authBox.get(authId);
  }

  // Get user by email
  AuthHiveModel? getUserByEmail(String email) {
    try {
      return _authBox.values.firstWhere((user) => user.email == email);
    } catch (e) {
      return null;
    }
  }

  // Update user
  Future<bool> updateUser(AuthHiveModel user) async {
    if (_authBox.containsKey(user.authId)) {
      await _authBox.put(user.authId, user);
      return true;
    }
    return false;
  }

  // Delete user
  Future<void> deleteUser(String authId) async {
    await _authBox.delete(authId);
  }

  // // ======================= Item Queries =========================

  // Box<ItemHiveModel> get _itemBox =>
  //     Hive.box<ItemHiveModel>(HiveTableConstantss.itemTable);

  // Future<ItemHiveModel> createItem(ItemHiveModel item) async {
  //   await _itemBox.put(item.itemId, item);
  //   return item;
  // }

  // List<ItemHiveModel> getAllItems() {
  //   return _itemBox.values.toList();
  // }

  // ItemHiveModel? getItemById(String itemId) {
  //   return _itemBox.get(itemId);
  // }

  // List<ItemHiveModel> getItemsByUser(String userId) {
  //   return _itemBox.values.where((item) => item.reportedBy == userId).toList();
  // }

  // List<ItemHiveModel> getLostItems() {
  //   return _itemBox.values.where((item) => item.type == 'lost').toList();
  // }

  // List<ItemHiveModel> getFoundItems() {
  //   return _itemBox.values.where((item) => item.type == 'found').toList();
  // }

  // List<ItemHiveModel> getItemsByCategory(String categoryId) {
  //   return _itemBox.values
  //       .where((item) => item.categoryId == categoryId)
  //       .toList();
  // }

  // Future<bool> updateItem(ItemHiveModel item) async {
  //   if (_itemBox.containsKey(item.itemId)) {
  //     await _itemBox.put(item.itemId, item);
  //     return true;
  //   }
  //   return false;
  // }

  // Future<void> deleteItem(String itemId) async {
  //   await _itemBox.delete(itemId);
  // }

  // ======================= Category Queries =========================

  Box<CategoryHiveModel> get _categoryBox =>
      Hive.box<CategoryHiveModel>(HiveTableConstants.categoryTable);

  Future<CategoryHiveModel> createCategory(CategoryHiveModel category) async {
    await _categoryBox.put(category.categoryId, category);
    return category;
  }

  List<CategoryHiveModel> getAllCategories() {
    return _categoryBox.values.toList();
  }

  CategoryHiveModel? getCategoryById(String categoryId) {
    return _categoryBox.get(categoryId);
  }

  Future<bool> updateCategory(CategoryHiveModel category) async {
    if (_categoryBox.containsKey(category.categoryId)) {
      await _categoryBox.put(category.categoryId, category);
      return true;
    }
    return false;
  }

  Future<void> deleteCategory(String categoryId) async {
    await _categoryBox.delete(categoryId);
  }
}
