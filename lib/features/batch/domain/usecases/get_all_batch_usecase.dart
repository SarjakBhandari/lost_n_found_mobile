//Params
// ignore: implementation_imports
import 'package:either_dart/src/either.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/usecases/app_usecases.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

class GetAllBatchUsecase implements UsecaseWithoutParms<List<BatchEntity>> {
  final IBatchRepository _batchRepository;
  GetAllBatchUsecase({required IBatchRepository batchrepository})
    : _batchRepository = batchrepository;

  @override
  Future<Either<Failure, List<BatchEntity>>> call() async {
    return _batchRepository.getAllBatches();
  }
}
