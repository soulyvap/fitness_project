import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/source/storage_firebase_service.dart';
import 'package:fitness_project/data/storage/models/upload_image_req.dart';
import 'package:fitness_project/domain/repository/storage/storage.dart';
import 'package:fitness_project/service_locator.dart';

class StorageRepositoryImpl extends StorageRepository {
  @override
  Future<Either> uploadFile(UploadFileReq uploadFileReq) async {
    var upload = await sl<StorageFirebaseService>().uploadFile(uploadFileReq);
    return upload.fold((error) {
      return Left(error);
    }, (data) {
      return Right(data);
    });
  }
}
