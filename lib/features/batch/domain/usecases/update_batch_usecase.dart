import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/batch/data/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batch_usecase.dart';

class UpdateBatchParams extends Equatable {
  final String batchId;
  final String batchName;
  final String? status;

  const UpdateBatchParams({
    required this.batchId,
    required this.batchName,
    this.status,
  });

  @override
  List<Object?> get props => [batchId, batchName, status];
}

final updateBatchUsecaseProvider = Provider<UpdateBatchUsecase>((ref) {
  return UpdateBatchUsecase(batchRepo: ref.read(batchRepositoryProvider));
});

class UpdateBatchUsecase implements UsecaseWithParms<bool, UpdateBatchParams> {
  final IBatchRepository _batchRepository;

  UpdateBatchUsecase({required IBatchRepository batchRepo})
    : _batchRepository = batchRepo;

  @override
  Future<Either<Failure, bool>> call(UpdateBatchParams params) {
    BatchEntity updateduser = BatchEntity(batchName: params.batchName);
    return _batchRepository.updateBatch(updateduser);
  }
}
