import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/db/models/update_group_req.dart';
import 'package:fitness_project/data/db/models/update_user_req.dart';

abstract class FirestoreFirebaseService {
  Future<Either> updateUser(UpdateUserReq updateUserReq);
  Future<Either> updateGroup(UpdateGroupReq updateGroupReq);
}

class FirestoreFirebaseServiceImpl extends FirestoreFirebaseService {
  @override
  Future<Either> updateUser(UpdateUserReq updateUserReq) async {
    final dataMap = updateUserReq.toMap();
    if (dataMap.keys.length == 1) {
      return const Left("Invalid data");
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updateUserReq.userId)
          .set(dataMap, SetOptions(merge: true));
      return const Right('User updated');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> updateGroup(UpdateGroupReq updateGroupReq) async {
    final dataMap = updateGroupReq.toMap();
    if (dataMap.keys.length == 1) {
      return const Left("Invalid data");
    }
    try {
      FirebaseFirestore.instance
          .collection('groups')
          .doc(updateGroupReq.groupeId)
          .set(dataMap, SetOptions(merge: true));
      return const Right('Group updated');
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
