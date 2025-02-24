import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_project/data/models/storage/upload_file_req.dart';

abstract class StorageFirebaseService {
  Future<Either> uploadFile(UploadFileReq uploadFileReq);
  Future<Either> delete(String path);
}

class StorageFirebaseServiceImpl implements StorageFirebaseService {
  final storageRef = FirebaseStorage.instance.ref();

  @override
  Future<Either> uploadFile(UploadFileReq uploadFileReq) async {
    final ref = storageRef.child(uploadFileReq.path);
    try {
      await ref.putFile(uploadFileReq.file);
      final url = await ref.getDownloadURL();
      return Right(url);
    } catch (e) {
      return Left(e);
    }
  }

  @override
  Future<Either> delete(String path) async {
    final ref = storageRef.child(path);
    try {
      await ref.delete();
      return const Right("file deleted");
    } catch (e) {
      return Left(e);
    }
  }
}
