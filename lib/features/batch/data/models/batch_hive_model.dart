import 'package:hive/hive.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/core/constants/hive_table_constants.dart';
import 'package:uuid/uuid.dart';

// part is generated file
part 'batch_hive_model.g.dart'; // dart run build_runner build --delete-conflicting-outputs

@HiveType(typeId: HiveTableConstants.batchTypeId)
class BatchHiveModel extends HiveObject {
  @HiveField(0)
  final String? batchId;
  @HiveField(1)
  final String? batchName;
  @HiveField(2)
  final String? status;

  BatchHiveModel({String? batchId, required this.batchName, String? status})
    : batchId = batchId ?? Uuid().v4(),
      status = status ?? "active";

  //ckinvert model to batch entity
  BatchEntity toEntity() {
    return BatchEntity(batchId: batchId, batchName: batchName, status: status);
  }

  //convert batch entity to model
  factory BatchHiveModel.fromEntity(BatchEntity entity) {
    return BatchHiveModel(batchName: entity.batchName);
  }

  //convert list of models to list of batch entities
  static List<BatchEntity> toEntityList(List<BatchHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
