//   Future<Either<Failure, bool>> deleteBatch(String batchId);

import 'package:either_dart/src/either.dart';
import 'package:equatable/equatable.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

class DeleteBatchParams extends Equatable {
  final String _batchId;
  const DeleteBatchParams({required String batchId}) : _batchId = batchId;

  @override
  List<Object?> get props => [_batchId];
}

class DeleteBatchUsecase implements UsecaseWithParms<bool, DeleteBatchParams> {
  final IBatchRepository _batchRepo;

  DeleteBatchUsecase({required IBatchRepository batchRepo})
    : _batchRepo = batchRepo;

  @override
  Future<Either<Failure, bool>> call(DeleteBatchParams params) {
    return _batchRepo.deleteBatch(params._batchId);
  }
}
