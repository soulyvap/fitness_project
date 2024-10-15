import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/storage/models/upload_file_req.dart';

abstract class StorageRepository {
  Future<Either> uploadFile(UploadFileReq uploadFileReq);
}
