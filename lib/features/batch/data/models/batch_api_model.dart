import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

class BatchApiModel {
  final String? id;
  final String? batchname;
  final String? status;

  BatchApiModel({this.id, required this.batchname, this.status});

  Map<String, dynamic> toJson() {
    return {"batchName": batchname};
  }

  factory BatchApiModel.fromJson(Map<String, dynamic> json) {
    return BatchApiModel(
      id: json['_id'] as String,
      batchname: json['batchName'] as String,
      status: json['status'] as String,
    );
  }

  BatchEntity toEntity() {
    return BatchEntity(batchName: batchname, batchId: id, status: status);
  }

  factory BatchApiModel.fromEntity(BatchEntity entity) {
    return BatchApiModel(batchname: entity.batchName);
  }

  static List<BatchEntity> toEntityList(List<BatchApiModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
