import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/extensions/string_list_extension.dart';
import 'package:fitness_project/data/db/models/add_group_member_req.dart';
import 'package:fitness_project/data/db/models/get_challenges_by_groups_req.dart';
import 'package:fitness_project/data/db/models/get_groups_by_user_req.dart';
import 'package:fitness_project/data/db/models/update_challenge_req.dart';
import 'package:fitness_project/data/db/models/update_group_req.dart';
import 'package:fitness_project/data/db/models/update_user_req.dart';

abstract class FirestoreFirebaseService {
  Future<Either> getUser(String? userId);
  Future<Either> updateUser(UpdateUserReq updateUserReq);
  Future<Either> updateGroup(UpdateGroupReq updateGroupReq);
  Future<Either> getUsersByDisplayName(String query);
  Future<Either> updateGroupMember(UpdateGroupMemberReq updateGroupMemberReq);
  Future<Either> getGroupsByUser(GetGroupsByUserReq getGroupsByUserReq);
  Future<Either> getAllExercises();
  Future<Either> updateChallenge(UpdateChallengeReq updateChallengeReq);
  Future<Either> getChallengesByGroups(
      GetChallengesByGroupsReq getChallengesByGroupsReq);
  Future<Either> getExerciseById(String exerciseId);
  Future<Either> getGroupById(String groupId);
  Future<Either> getChallengeById(String challengeId);
}

class FirestoreFirebaseServiceImpl extends FirestoreFirebaseService {
  @override
  Future<Either> getUser(String? userId) async {
    try {
      var userIdUsed = userId ?? FirebaseAuth.instance.currentUser?.uid;
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(userIdUsed)
          .get()
          .then((value) => value.data());
      return Right(userData);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> updateUser(UpdateUserReq updateUserReq) async {
    final dataMap = updateUserReq.toMap();
    if (dataMap.keys.length == 1) {
      return const Left("Invalid data");
    }
    final userId = updateUserReq.userId ??
        FirebaseFirestore.instance.collection('users').doc().id;
    dataMap['userId'] = userId;
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
    dataMap['groupId'] = groupId;
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
  Future<Either> updateGroupMember(
      UpdateGroupMemberReq updateGroupMemberReq) async {
    var dataMap = updateGroupMemberReq.toMap();
    if (dataMap.keys.length == 1) {
      return const Left("Invalid data");
    }
    final groupId = updateGroupMemberReq.groupId;
    final groupMemberId = updateGroupMemberReq.groupMemberId ??
        FirebaseFirestore.instance
            .collection('groups')
            .doc(groupId)
            .collection('members')
            .doc()
            .id;
    dataMap['groupMemberId'] = groupMemberId;
    try {
      await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .doc(groupMemberId)
          .set(dataMap, SetOptions(merge: true));
      return const Right('User added to group');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getGroupsByUser(GetGroupsByUserReq getGroupsByUserReq) async {
    try {
      final groups = getGroupsByUserReq.onlyActive
          ? await FirebaseFirestore.instance
              .collection('groups')
              .where('members', arrayContains: getGroupsByUserReq.userId)
              .where('startTime', isLessThan: Timestamp.now())
              .where('endTime', isGreaterThan: Timestamp.now())
              .get()
              .then((value) => value.docs.map((d) => d.data()).toList())
          : await FirebaseFirestore.instance
              .collection('groups')
              .where('members', arrayContains: getGroupsByUserReq.userId)
              .get()
              .then((value) => value.docs.map((d) => d.data()).toList());
      return Right(groups);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getAllExercises() async {
    try {
      final exercises = await FirebaseFirestore.instance
          .collection('exercises')
          .get()
          .then((value) => value.docs.map((d) => d.data()).toList());
      return Right(exercises);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> updateChallenge(UpdateChallengeReq updateChallengeReq) async {
    final dataMap = updateChallengeReq.toMap();
    if (dataMap.keys.length == 1) {
      return const Left("Invalid data");
    }
    final challengeId = updateChallengeReq.challengeId ??
        FirebaseFirestore.instance.collection('challenges').doc().id;
    dataMap['challengeId'] = challengeId;

    if (updateChallengeReq.challengeId == null) {
      dataMap['createdAt'] = Timestamp.now();
      dataMap['endsAt'] = Timestamp.fromDate(
          DateTime.now().add(Duration(minutes: dataMap['minutesToComplete'])));
    }
    try {
      await FirebaseFirestore.instance
          .collection('challenges')
          .doc(challengeId)
          .set(dataMap, SetOptions(merge: true));
      return Right(challengeId);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getChallengesByGroups(
      GetChallengesByGroupsReq getChallengesByGroupsReq) async {
    var toBeFetched = getChallengesByGroupsReq.groupIds.toChunks(25);
    List<Map<String, dynamic>> challenges = [];
    try {
      for (var chunk in toBeFetched) {
        final chunkChallenges = getChallengesByGroupsReq.onlyActive
            ? await FirebaseFirestore.instance
                .collection('challenges')
                .where('groupId', whereIn: chunk)
                .where('endsAt', isGreaterThan: Timestamp.now())
                .get()
                .then((value) => value.docs.map((d) => d.data()).toList())
            : await FirebaseFirestore.instance
                .collection('challenges')
                .where('groupId', whereIn: chunk)
                .get()
                .then((value) => value.docs.map((d) => d.data()).toList());
        challenges.addAll(chunkChallenges);
      }
      return Right(challenges);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getExerciseById(String exerciseId) async {
    try {
      final exercise = await FirebaseFirestore.instance
          .collection('exercises')
          .doc(exerciseId)
          .get()
          .then((value) => value.data());
      return Right(exercise);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getChallengeById(String challengeId) async {
    try {
      final challenge = await FirebaseFirestore.instance
          .collection('challenges')
          .doc(challengeId)
          .get()
          .then((value) => value.data());
      return Right(challenge);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> getGroupById(String groupId) async {
    try {
      final group = await FirebaseFirestore.instance
          .collection('groups')
          .doc(groupId)
          .get()
          .then((value) => value.data());
      return Right(group);
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
