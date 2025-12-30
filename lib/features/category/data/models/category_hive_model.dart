import 'package:hive/hive.dart';
import 'package:lost_n_found/core/constants/hive_table_constants.dart';

import 'package:lost_n_found/features/category/domain/entities/category_entity.dart';
import 'package:uuid/uuid.dart';

part 'category_hive_model.g.dart';

@HiveType(typeId: HiveTableConstants.categoryTypeId)
class CategoryHiveModel extends HiveObject {
  @HiveField(0)
  final String? categoryId;

  @HiveField(1)
  final String categoryName;

  @HiveField(2)
  final String? description;

  @HiveField(3)
  final String? status;

  CategoryHiveModel({
    String? categoryId,
    required this.categoryName,
    this.description,
    String? status,
  }) : categoryId = categoryId ?? const Uuid().v4(),
       status = status ?? 'active';

  CategoryEntity toEntity() {
    return CategoryEntity(
      categoryId: categoryId,
      categoryName: categoryName,
      description: description,
      status: status,
    );
  }

  factory CategoryHiveModel.fromEntity(CategoryEntity entity) {
    return CategoryHiveModel(
      categoryId: entity.categoryId,
      categoryName: entity.categoryName ?? "",
      description: entity.description,
      status: entity.status,
    );
  }

  static List<CategoryEntity> toEntityList(List<CategoryHiveModel> models) {
    return models.map((model) => model.toEntity()).toList();
  }
}
