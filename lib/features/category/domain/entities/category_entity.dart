import 'package:equatable/equatable.dart';

class CategoryEntity extends Equatable {
  final String? categoryId;
  final String categoryName;
  final String? description;
  final String? status;

  const CategoryEntity({
    this.categoryId,
    required this.categoryName,
    this.description,
    this.status,
  });
  @override
  List<Object?> get props => [categoryId, categoryName, description, status];
}
