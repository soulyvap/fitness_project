import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/domain/repository/storage/storage.dart';
import 'package:fitness_project/service_locator.dart';

class UploadFileUseCase extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) async {
    return await sl<StorageRepository>().uploadFile(params);
  }
}
