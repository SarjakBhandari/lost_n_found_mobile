import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constants.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:path_provider/path_provider.dart';

class HiveService {
  Future<void> init() async {
    final directory = await getApplicationDocumentsDirectory();
    final path = '${directory.path}/${HiveTableConstants.dbName}}';
    Hive.init(path);
    _registerAdapters();
    await _openBoxes();
  }

  void _registerAdapters() {
    if (!Hive.isAdapterRegistered(HiveTableConstants.batchTypeId)) {
      Hive.registerAdapter(BatchHiveModelAdapter());
    }
  }

  //open all boxes
  Future<void> _openBoxes() async {
    await Hive.openBox<BatchHiveModel>(HiveTableConstants.batchTable);
  }

  //delete all boxes
  Future<void> deleteAllBatch() async {
    await _batchBox.clear();
  }

  //close all boxes
  Future<void> close() async {
    await Hive.close();
  }

  // ==================== Batch CRUD Operations ================================

  // get batch box
  Box<BatchHiveModel> get _batchBox =>
      Hive.box<BatchHiveModel>(HiveTableConstants.batchTable);

  //create a new batch
  Future<BatchHiveModel> createBatch(BatchHiveModel batch) async {
    await _batchBox.put(batch.batchId, batch);
    return batch;
  }

  //get batch by ID
  BatchHiveModel? getBatchById(String batchId) {
    return _batchBox.get(batchId);
  }

  //update a batch
  Future<void> updateBatch(BatchHiveModel batch) async {
    await _batchBox.put(batch.batchId, batch);
  }

  //delete a batch
  Future<void> deleteBatch(String batchId) async {
    await _batchBox.delete(batchId);
  }

  // Get all batches
  List<BatchHiveModel>? getAllBatches() {
    return _batchBox.values.toList();
  }
}
