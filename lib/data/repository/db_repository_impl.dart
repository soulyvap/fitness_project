import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/db/models/update_group_req.dart';
import 'package:fitness_project/data/db/models/update_user_req.dart';
import 'package:fitness_project/data/source/firestore_firebase_service.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class DBRepositoryImpl extends DBRepository {
  @override
  Future<Either> updateUser(UpdateUserReq updateUserReq) {
    return sl<FirestoreFirebaseService>().updateUser(updateUserReq);
  }

  @override
  Future<Either> updateGroup(UpdateGroupReq updateGroupReq) {
    return sl<FirestoreFirebaseService>().updateGroup(updateGroupReq);
  }
}
