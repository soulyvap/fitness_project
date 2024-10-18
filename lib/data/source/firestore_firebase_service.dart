import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/db/models/add_group_member_req.dart';
import 'package:fitness_project/data/db/models/update_group_req.dart';
import 'package:fitness_project/data/db/models/update_user_req.dart';

abstract class FirestoreFirebaseService {
  Future<Either> updateUser(UpdateUserReq updateUserReq);
  Future<Either> updateGroup(UpdateGroupReq updateGroupReq);
  Future<Either> getUsersByDisplayName(String query);
  Future<Either> addGroupMember(AddGroupMemberReq addGroupMemberReq);
}

class FirestoreFirebaseServiceImpl extends FirestoreFirebaseService {
  @override
  Future<Either> updateUser(UpdateUserReq updateUserReq) async {
    final dataMap = updateUserReq.toMap();
    if (dataMap.keys.length == 1) {
      return const Left("Invalid data");
    }
    final userId = updateUserReq.userId ??
        FirebaseFirestore.instance.collection('users').doc().id;
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set(dataMap, SetOptions(merge: true));
      return Right(userId);
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
    final groupId = updateGroupReq.groupId ??
        FirebaseFirestore.instance.collection('groups').doc().id;
    try {
      FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .set(dataMap, SetOptions(merge: true));
      return Right(groupId);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getUsersByDisplayName(String query) async {
    try {
      final users = await FirebaseFirestore.instance
          .collection('users')
          .where('displayName', isGreaterThanOrEqualTo: query)
          .where('displayName', isLessThan: '${query}z')
          .get()
          .then((value) => value.docs.map((d) => d.data()).toList());
      return Right(users);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> addGroupMember(AddGroupMemberReq addGroupMemberReq) async {
    final ref = FirebaseFirestore.instance
        .collection('groups')
        .doc(addGroupMemberReq.groupId)
        .collection("members")
        .doc();
    var dataMap = addGroupMemberReq.toMap();
    dataMap['groupMemberId'] = ref.id;
    try {
      await ref.set(dataMap);
      return const Right('User added to group');
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
