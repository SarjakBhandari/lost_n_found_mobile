import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/core/services/connectivity/network_info.dart';
import 'package:lost_n_found/features/batch/data/datasources/batch_datasource.dart';
import 'package:lost_n_found/features/batch/data/datasources/local/batch_local_datasource.dart';
import 'package:lost_n_found/features/batch/data/datasources/remote/batch_remote_datasource.dart';
import 'package:lost_n_found/features/batch/data/models/batch_api_model.dart';
import 'package:lost_n_found/features/batch/data/models/batch_hive_model.dart';
import 'package:lost_n_found/features/batch/domain/entities/batch_entity.dart';
import 'package:lost_n_found/features/batch/domain/repositories/batch_repository.dart';

// Create provider
final batchRepositoryProvider = Provider<IBatchRepository>((ref) {
  final batchLocalDatasource = ref.read(batchLocalDataSourceProvider);
  final batchRemoteDatasource = ref.read(batchRemoteProvider);
  final networkInfo = ref.read(networkInfoProvider);
  return BatchRepository(
    batchDatasource: batchLocalDatasource,
    iBatchRemoteDataSource: batchRemoteDatasource,
    networkInfo: networkInfo,
  );
});

class BatchRepository implements IBatchRepository {
  final IBatchLocalDataSource _batchDataSource;
  final IBatchRemoteDataSource _iBatchRemoteDataSource;
  final NetworkInfo _networkInfo;

  BatchRepository({
    required IBatchLocalDataSource batchDatasource,
    required iBatchRemoteDataSource,
    required networkInfo,
  }) : _batchDataSource = batchDatasource,
       _iBatchRemoteDataSource = iBatchRemoteDataSource,
       _networkInfo = networkInfo;

  @override
  Future<Either<Failure, bool>> createBatch(BatchEntity batch) async {
    try {
      // conversion
      // entity lai model ma convert gara
      final batchModel = BatchHiveModel.fromEntity(batch);
      final result = await _batchDataSource.createBatch(batchModel);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to create a batch"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> deleteBatch(String batchId) async {
    try {
      final result = await _batchDataSource.deleteBatch(batchId);
      if (result) {
        return Right(true);
      }

      return Left(LocalDatabaseFailure(message: ' Failed to delete batch'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<BatchEntity>>> getAllBatches() async {
    if (await _networkInfo.isConnected) {
      try {
        final apiModels = await _iBatchRemoteDataSource.getAllBatches();
        final result = BatchApiModel.toEntityList(apiModels ?? []);
        return Right(result);
      } on DioException catch (e) {
        return Left(
          ApiFailure(
            statusCode: e.response?.statusCode,
            message: e.response?.data['message'] ?? "Failed to fetch batch",
          ),
        );
      }
    } else {
      try {
        final models = await _batchDataSource.getAllBatches();
        final entities = BatchHiveModel.toEntityList(models ?? []);
        return Right(entities);
      } catch (e) {
        return Left(LocalDatabaseFailure(message: e.toString()));
      }
    }
  }

  @override
  Future<Either<Failure, BatchEntity>> getBatchById(String batchId) async {
    try {
      final model = await _batchDataSource.getBatchById(batchId);
      if (model != null) {
        final entity = model.toEntity();
        return Right(entity);
      }
      return Left(LocalDatabaseFailure(message: 'Batch not found'));
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, bool>> updateBatch(BatchEntity batch) async {
    try {
      final batchModel = BatchHiveModel.fromEntity(batch);
      final result = await _batchDataSource.updateBatch(batchModel);
      if (result) {
        return const Right(true);
      }
      return const Left(
        LocalDatabaseFailure(message: "Failed to update batch"),
      );
    } catch (e) {
      return Left(LocalDatabaseFailure(message: e.toString()));
    }
  }
}
