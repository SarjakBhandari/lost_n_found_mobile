import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:lost_n_found/core/error/failures.dart';
import 'package:lost_n_found/features/batch/domain/usecases/create_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/delete_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/get_all_batch_usecase.dart';
import 'package:lost_n_found/features/batch/domain/usecases/update_batch_usecase.dart';
import 'package:lost_n_found/features/batch/presentation/state/batch_status_state.dart';

class BatchViewmodel extends Notifier<BatchStatusState> {
  late final GetAllBatchUsecase _getAllBatchUsecase;
  late final CreateBatchUsecase _createBatchUsecase;
  late final UpdateBatchUsecase _updateBatchUsecase;
  late final DeleteBatchUsecase _deleteBatchUsecase;

  @override
  BatchStatusState build() {
    return const BatchStatusState();
  }

  Future<void> getAllBatches() async {
    state = state.copyWith(status: BatchStatus.loading);
    final result = await _getAllBatchUsecase();
    result.fold(
      (failure) => state = state.copyWith(
        status: BatchStatus.error,
        errorMessage: failure.message,
      ),
      (batches) =>
          state = state.copyWith(status: BatchStatus.loaded, batches: batches),
    );
  }

  Future<void> createBatch(String batchName) async {
    state = state.copyWith(status: BatchStatus.loading);
    final result = await _createBatchUsecase(
      CreateBatchParams(batchName: batchName),
    );

    result.fold(
      (failure) => state = state.copyWith(
        status: BatchStatus.error,
        errorMessage: failure.message,
      ),
      (_) {
        state = state.copyWith(status: BatchStatus.created);
        getAllBatches();
      },
    );
  }

  Future<void> updateBatch({
    required String batchld,
    required String batchName,
    String? status,
  }) async {
    state = state.copyWith(status: BatchStatus.loading);
    final result = await _updateBatchUsecase(
      UpdateBatchParams(batchId: batchld, batchName: batchName, status: status),
    );
    result.fold(
      (failure) => state = state.copyWith(
        status: BatchStatus.error,
        errorMessage: failure.message,
      ),
      (_) {
        state = state.copyWith(status: BatchStatus.updated);

        getAllBatches();
      },
    );
  }

  Future<void> deleteBatch(String batchld) async {
    state = state.copyWith(status: BatchStatus.loading);

    final result = await _deleteBatchUsecase(
      DeleteBatchParams(batchId: batchld),
    );
    result.fold(
      (failure) => state = state.copyWith(
        status: BatchStatus.error,
        errorMessage: failure.message,
      ),
      (_) {
        state = state.copyWith(status: BatchStatus.deleted);

        getAllBatches();
      },
    );
  }
}
