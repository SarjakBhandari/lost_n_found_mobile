import 'package:equatable/equatable.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';

enum BatchStatus { initual, loading, loaded, error, created, updated, deleted }

class BatchStatusState extends Equatable {
  final BatchStatus status;
  final List<BatchEntity> batches;
  final String? errorMessage;

  const BatchStatusState({
    this.status = BatchStatus.initual,
    this.batches = const [],
    this.errorMessage,
  });

  BatchStatusState copyWith({
    BatchStatus? status,
    List<BatchEntity>? batches,
    String? errorMessage,
  }) {
    return BatchStatusState(
      status: status ?? this.status,
      batches: batches ?? this.batches,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, batches, errorMessage];
}
