import 'package:dartz/dartz.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:fitness_project/data/storage/models/upload_file_req.dart';

abstract class StorageFirebaseService {
  Future<Either> uploadFile(UploadFileReq uploadFileReq);
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
}
