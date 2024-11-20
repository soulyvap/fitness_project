import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/models/storage/upload_file_req.dart';

abstract class StorageRepository {
  Future<Either> uploadFile(UploadFileReq uploadFileReq);
  Future<Either> delete(String path);
}
