import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/common/extensions/string_list_extension.dart';
import 'package:fitness_project/data/models/db/add_group_member_req.dart';
import 'package:fitness_project/data/models/db/edit_group_user_array_req.dart';
import 'package:fitness_project/data/models/db/add_score_req.dart';
import 'package:fitness_project/data/models/db/add_submission_seen_req.dart';
import 'package:fitness_project/data/models/db/challenge.dart';
import 'package:fitness_project/data/models/db/get_challenges_by_groups_req.dart';
import 'package:fitness_project/data/models/db/get_groups_by_user_req.dart';
import 'package:fitness_project/data/models/db/get_scores_by_challenge_and_user_req.dart';
import 'package:fitness_project/data/models/db/get_submission_by_challenge_and_user_req.dart';
import 'package:fitness_project/data/models/db/update_challenge_req.dart';
import 'package:fitness_project/data/models/db/update_comment_req.dart';
import 'package:fitness_project/data/models/db/update_group_req.dart';
import 'package:fitness_project/data/models/db/update_like_req.dart';
import 'package:fitness_project/data/models/db/update_submission_req.dart';
import 'package:fitness_project/data/models/db/update_user_req.dart';
import 'package:fitness_project/domain/entities/db/score.dart';

abstract class FirestoreFirebaseService {
  Future<Either> addScores(List<AddScoreReq> addScoreReqs);
  Future<Either> getAllExercises();
  Future<Either> getChallengeById(String challengeId);
  Future<Either> getChallengesByGroups(
      GetChallengesByGroupsReq getChallengesByGroupsReq);
  Future<Either> getExerciseById(String exerciseId);
  Future<Either> getGroupById(String groupId);
  Future<Either> getGroupsByUser(GetGroupsByUserReq getGroupsByUserReq);
  Future<Either> getScoresBySubmission(String submissionId);
  Future<Either> getScoresByChallengeAndUser(
      GetScoresByChallengeAndUserReq getScoresByChallengeAndUserReq);
  Future<Either> getSubmissionByChallengeAndUser(
      GetSubmissionByChallengeAndUserReq getSubmissionByChallengeAndUserReq);
  Future<Either> getSubmissionById(String submissionId);
  Future<Either> getUser(String? userId);
  Future<Either> getUsersByDisplayName(String query);
  Future<Either> updateChallenge(UpdateChallengeReq updateChallengeReq);
  Future<Either> updateGroup(UpdateGroupReq updateGroupReq);
  Future<Either> updateGroupMember(UpdateGroupMemberReq updateGroupMemberReq);
  Future<Either> updateSubmission(UpdateSubmissionReq updateSubmissionReq);
  Future<Either> updateUser(UpdateUserReq updateUserReq);
  Future<Either> getSubmissionsByChallenge(String challengeId);
  Future<Either> getSubmissionsByGroups(List<String> groupIds);
  Future<Either> addSubmissionSeen(AddSubmissionSeenReq addSubmissionSeenReq);
  Future<Either> updateLike(UpdateLikeReq updateLikeReq);
  Future<Either> updateComment(UpdateCommentReq updateCommentReq);
  Future<Either> getCommentsBySubmission(String submissionId);
  Future<Either> getUsersByIds(List<String> userIds);
  Future<Either> getScoresByGroup(String groupId);
  Future<Either> getPreviousEndedChallenge(String groupId);
  Future<Either> editGroupUserArray(
      EditGroupUserArrayReq editGroupUserArrayReq);
  Future<Either> updateFcmToken(String token);
  Future<Either> deleteSubmission(String submissionId);
  Future<Either> getChallengeListener(String challengeId);
}

class FirestoreFirebaseServiceImpl extends FirestoreFirebaseService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? _currentUserId() => FirebaseAuth.instance.currentUser?.uid;

  @override
  Future<Either> addScores(List<AddScoreReq> addScoreReqs) async {
    var batch = _firestore.batch();

    for (var addScoreReq in addScoreReqs) {
      final dataMap = addScoreReq.toMap();
      final scoreId = _firestore.collection('scores').doc().id;
      dataMap['scoreId'] = scoreId;
      dataMap['createdAt'] = Timestamp.now();
      batch.set(_firestore.collection('scores').doc(scoreId), dataMap);
    }

    try {
      await batch.commit();
      return const Right('Scores added');
    } catch (e) {
      return Left('Failed to add scores: ${e.toString()}');
    }
  }

  @override
  Future<Either> getAllExercises() async {
    try {
      final exercises = await _firestore
          .collection('exercises')
          .get()
          .then((value) => value.docs.map((d) => d.data()).toList());
      return Right(exercises);
    } catch (e) {
      return Left('Failed to get exercises: ${e.toString()}');
    }
  }

  @override
  Future<Either> getChallengeById(String challengeId) async {
    try {
      final challenge = await _firestore
          .collection('challenges')
          .doc(challengeId)
          .get()
          .then((value) => value.data());
      return Right(challenge);
    } catch (e) {
      return Left('Failed to get challenge by id: $challengeId');
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
            ? await _firestore
                .collection('challenges')
                .where('groupId', whereIn: chunk)
                .where('endsAt', isGreaterThan: Timestamp.now())
                .get()
                .then((value) => value.docs.map((d) => d.data()).toList())
            : await _firestore
                .collection('challenges')
                .where('groupId', whereIn: chunk)
                .get()
                .then((value) => value.docs.map((d) => d.data()).toList());
        challenges.addAll(chunkChallenges);
      }
      return Right(challenges);
    } catch (e) {
      return Left('Failed to get challenges by groups: ${e.toString()}');
    }
  }

  @override
  Future<Either> getExerciseById(String exerciseId) async {
    try {
      final exercise = await _firestore
          .collection('exercises')
          .doc(exerciseId)
          .get()
          .then((value) => value.data());
      return Right(exercise);
    } catch (e) {
      return Left('Failed to get exercise by id: $e');
    }
  }

  @override
  Future<Either> getGroupById(String groupId) async {
    try {
      final group = await _firestore
          .collection('groups')
          .doc(groupId)
          .get()
          .then((value) => value.data());
      return Right(group);
    } catch (e) {
      return Left('Failed to get group by id: $e');
    }
  }

  @override
  Future<Either> getGroupsByUser(GetGroupsByUserReq getGroupsByUserReq) async {
    try {
      final groups = getGroupsByUserReq.onlyActive
          ? await _firestore
              .collection('groups')
              .where('allowedUsers', arrayContains: getGroupsByUserReq.userId)
              .where('startTime', isLessThan: Timestamp.now())
              .where('endTime', isGreaterThan: Timestamp.now())
              .get()
              .then((value) => value.docs.map((d) => d.data()).toList())
          : await _firestore
              .collection('groups')
              .where('allowedUsers', arrayContains: getGroupsByUserReq.userId)
              .get()
              .then((value) => value.docs.map((d) => d.data()).toList());
      return Right(groups);
    } catch (e) {
      return Left('Failed to get groups by user: $e');
    }
  }

  @override
  Future<Either> getScoresBySubmission(String submissionId) async {
    try {
      final scores = await _firestore
          .collection('scores')
          .where('submissionId', isEqualTo: submissionId)
          .get()
          .then((value) => value.docs.map((d) => d.data()).toList());
      return Right(scores);
    } catch (e) {
      return Left("Failed to get scores: $e");
    }
  }

  @override
  Future<Either> getSubmissionByChallengeAndUser(
      GetSubmissionByChallengeAndUserReq
          getSubmissionByChallengeAndUserReq) async {
    try {
      final submission = await _firestore
          .collection('submissions')
          .where('challengeId',
              isEqualTo: getSubmissionByChallengeAndUserReq.challengeId)
          .where('userId', isEqualTo: getSubmissionByChallengeAndUserReq.userId)
          .orderBy('createdAt', descending: true)
          .limit(1)
          .get()
          .then((value) => value.docs.map((d) => d.data()).toList());
      if (submission.isEmpty) {
        return const Left('Submission not found');
      }
      return Right(submission.first);
    } catch (e) {
      return Left('Failed to get submission: $e');
    }
  }

  @override
  Future<Either> getSubmissionById(String submissionId) async {
    try {
      final submission = await _firestore
          .collection('submissions')
          .doc(submissionId)
          .get()
          .then((value) => value.data());
      return Right(submission);
    } catch (e) {
      return Left('Failed to get submission: $e');
    }
  }

  @override
  Future<Either> getUser(String? userId) async {
    try {
      var userIdUsed = userId ?? _currentUserId();
      var userData = await _firestore
          .collection('users')
          .doc(userIdUsed)
          .get()
          .then((value) => value.data());
      return Right(userData);
    } catch (e) {
      return Left('Failed to get user: $e');
    }
  }

  @override
  Future<Either> getUsersByDisplayName(String query) async {
    try {
      final users = await _firestore
          .collection('users')
          .where('displayName', isGreaterThanOrEqualTo: query)
          .where('displayName', isLessThan: '${query}z')
          .get()
          .then((value) => value.docs.map((d) => d.data()).toList());
      return Right(users);
    } catch (e) {
      return Left('Failed to get users by display name: $e');
    }
  }

  Future<void> onAddSubmission(String submissionId, String challengeId) async {
    final currentUserId = _currentUserId();
    if (currentUserId == null) {
      throw Exception('User not found');
    }
    List<ScoreType> scoreTypes = [
      ScoreType.challengeParticipation,
    ];
    if (FirebaseAuth.instance.currentUser?.uid == null) {
      throw Exception('User not found');
    }

    try {
      final challenge = await _firestore
          .collection('challenges')
          .doc(challengeId)
          .get()
          .then((value) => value.data());

      if (challenge == null) {
        throw Exception('Challenge not found');
      }

      final author = challenge["userId"] as String;
      final completedBy = (challenge["completedBy"] as List<dynamic>)
          .map((e) => e.toString())
          .toList();
      final groupId = challenge["groupId"] as String;
      final isAuthor = author == _currentUserId();
      if (!isAuthor) {
        final placement = completedBy.indexOf(currentUserId) + 1;
        switch (placement) {
          case 1:
            scoreTypes.add(ScoreType.challengeEarlyParticipation1);
            break;
          case 2:
            scoreTypes.add(ScoreType.challengeEarlyParticipation2);
            break;
          case 3:
            scoreTypes.add(ScoreType.challengeEarlyParticipation3);
            break;
          case 4:
            scoreTypes.add(ScoreType.challengeEarlyParticipation4);
            break;
          case 5:
            scoreTypes.add(ScoreType.challengeEarlyParticipation5);
            break;
          default:
            break;
        }
      }
      final hasStreak = await userHasStreak(groupId);
      if (hasStreak) {
        scoreTypes.add(ScoreType.challengeParticipationStreak);
      }

      List<AddScoreReq> scores = scoreTypes
          .map((type) => AddScoreReq(
              challengeId: challengeId,
              userId: currentUserId,
              points: type.value,
              type: type.name,
              groupId: groupId,
              submissionId: submissionId))
          .toList();

      await addScores(scores);
    } catch (e) {
      throw Exception('Error adding scores: $e');
    }
  }

  @override
  Future<Either> updateChallenge(UpdateChallengeReq updateChallengeReq) async {
    final currentUserId = _currentUserId();
    final isAdd = updateChallengeReq.challengeId == null;
    final dataMap = updateChallengeReq.toMap();
    if (dataMap.keys.length == 1) {
      return const Left("Invalid data");
    }
    final challengeId = updateChallengeReq.challengeId ??
        _firestore.collection('challenges').doc().id;
    dataMap['challengeId'] = challengeId;

    if (isAdd) {
      dataMap['createdAt'] = Timestamp.now();
      dataMap['endsAt'] = Timestamp.fromDate(
          DateTime.now().add(Duration(minutes: dataMap['minutesToComplete'])));
      if (currentUserId == null) {
        return const Left('User not found');
      }
      await addScores([
        AddScoreReq(
            challengeId: challengeId,
            userId: currentUserId,
            points: ScoreType.challengeCreation.value,
            type: ScoreType.challengeCreation.name,
            groupId: dataMap['groupId'])
      ]);
    }
    try {
      await _firestore
          .collection('challenges')
          .doc(challengeId)
          .set(dataMap, SetOptions(merge: true));
      return Right(challengeId);
    } catch (e) {
      return Left('Failed to update challenge: ${e.toString()}');
    }
  }

  @override
  Future<Either> updateGroup(UpdateGroupReq updateGroupReq) async {
    final isAdd = updateGroupReq.groupId == null;
    final dataMap = updateGroupReq.toMap();
    if (dataMap.keys.length == 1) {
      return const Left("Invalid data");
    }
    final groupId =
        updateGroupReq.groupId ?? _firestore.collection('groups').doc().id;
    dataMap['groupId'] = groupId;

    if (isAdd) {
      dataMap['createdAt'] = Timestamp.now();
    }
    try {
      _firestore
          .collection('groups')
          .doc(groupId)
          .set(dataMap, SetOptions(merge: true));
      return Right(groupId);
    } catch (e) {
      return Left('Failed to update group: ${e.toString()}');
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
        _firestore
            .collection('groups')
            .doc(groupId)
            .collection('members')
            .doc()
            .id;
    dataMap['groupMemberId'] = groupMemberId;
    try {
      await _firestore
          .collection('groups')
          .doc(groupId)
          .collection('members')
          .doc(groupMemberId)
          .set(dataMap, SetOptions(merge: true));
      return const Right('User added to group');
    } catch (e) {
      return Left('Failed to add user to group: ${e.toString()}');
    }
  }

  @override
  Future<Either> updateSubmission(
      UpdateSubmissionReq updateSubmissionReq) async {
    bool isAdd = updateSubmissionReq.submissionId == null;
    final dataMap = updateSubmissionReq.toMap();
    if (dataMap.keys.length == 1) {
      return const Left("Invalid data");
    }
    final submissionId = updateSubmissionReq.submissionId ??
        _firestore.collection('submissions').doc().id;
    dataMap['submissionId'] = submissionId;

    if (isAdd) {
      dataMap['createdAt'] = Timestamp.now();
      dataMap['seenBy'] = [];
      dataMap['likedBy'] = [];
      dataMap['commentCount'] = 0;
      final challengeId = updateSubmissionReq.challengeId;
      try {
        final userId = _currentUserId();
        await _firestore.collection('challenges').doc(challengeId).update({
          'completedBy': FieldValue.arrayUnion([userId])
        });
      } catch (e) {
        log(e.toString());
      }
    }
    try {
      await _firestore
          .collection('submissions')
          .doc(submissionId)
          .set(dataMap, SetOptions(merge: true));
      if (isAdd) {
        if (updateSubmissionReq.challengeId == null) {
          throw Exception('Missing challengeId');
        }
        await onAddSubmission(submissionId, updateSubmissionReq.challengeId!);
      }
      return Right(submissionId);
    } catch (e) {
      return Left('Failed to update submission: ${e.toString()}');
    }
  }

  @override
  Future<Either> updateUser(UpdateUserReq updateUserReq) async {
    final dataMap = updateUserReq.toMap();
    if (dataMap.keys.length == 1) {
      return const Left("Invalid data");
    }
    final userId =
        updateUserReq.userId ?? _firestore.collection('users').doc().id;
    dataMap['userId'] = userId;
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .set(dataMap, SetOptions(merge: true));
      return Right(userId);
    } catch (e) {
      return Left('Failed to update user: ${e.toString()}');
    }
  }

  Future<bool> userHasStreak(String groupId) async {
    final previousChallenges = await _firestore
        .collection('challenges')
        .where('groupId', isEqualTo: groupId)
        .where('endsAt', isLessThan: Timestamp.now())
        .orderBy('endsAt', descending: true)
        .limit(1)
        .get()
        .then((value) =>
            value.size > 0 ? value.docs.map((d) => d.data()).toList() : []);

    if (previousChallenges.isEmpty) {
      return false;
    }
    final previousChallenge = ChallengeModel.fromMap(previousChallenges.first);
    return previousChallenge.completedBy.contains(_currentUserId());
  }

  @override
  Future<Either> getScoresByChallengeAndUser(
      GetScoresByChallengeAndUserReq getScoresByChallengeAndUserReq) async {
    try {
      final scores = await _firestore
          .collection('scores')
          .where('challengeId',
              isEqualTo: getScoresByChallengeAndUserReq.challengeId)
          .where('userId', isEqualTo: getScoresByChallengeAndUserReq.userId)
          .get()
          .then((value) => value.docs.map((d) => d.data()).toList());
      return Right(scores);
    } catch (e) {
      return Left("Failed to get scores: $e");
    }
  }

  @override
  Future<Either> getSubmissionsByChallenge(String challengeId) async {
    try {
      final submissions = await _firestore
          .collection('submissions')
          .where('challengeId', isEqualTo: challengeId)
          .get()
          .then((value) => value.docs.map((d) => d.data()).toList());
      return Right(submissions);
    } catch (e) {
      return Left('Failed to get submissions by challenge: ${e.toString()}');
    }
  }

  @override
  Future<Either> getSubmissionsByGroups(List<String> groupIds) async {
    var toBeFetched = groupIds.toChunks(25);
    List<Map<String, dynamic>> challenges = [];
    try {
      for (var chunk in toBeFetched) {
        final chunkChallenges = await _firestore
            .collection('submissions')
            .where('groupId', whereIn: chunk)
            .get()
            .then((value) => value.docs.map((d) => d.data()).toList());
        challenges.addAll(chunkChallenges);
      }
      return Right(challenges);
    } catch (e) {
      return Left('Failed to get challenges by groups: ${e.toString()}');
    }
  }

  @override
  Future<Either> addSubmissionSeen(
      AddSubmissionSeenReq addSubmissionSeenReq) async {
    try {
      await _firestore
          .collection('submissions')
          .doc(addSubmissionSeenReq.submissionId)
          .update({
        'seenBy': FieldValue.arrayUnion([addSubmissionSeenReq.userId])
      });
      return const Right('Seenby added');
    } catch (e) {
      return Left('Failed to add submission seen: ${e.toString()}');
    }
  }

  @override
  Future<Either> updateLike(UpdateLikeReq updateLikeReq) async {
    try {
      if (updateLikeReq.isLiked) {
        await _firestore
            .collection('submissions')
            .doc(updateLikeReq.submissionId)
            .update({
          'likedBy': FieldValue.arrayUnion([updateLikeReq.userId])
        });
      } else {
        await _firestore
            .collection('submissions')
            .doc(updateLikeReq.submissionId)
            .update({
          'likedBy': FieldValue.arrayRemove([updateLikeReq.userId])
        });
      }
      return const Right('Like updated');
    } catch (e) {
      return Left('Failed to update like: ${e.toString()}');
    }
  }

  Future<void> incrementCommentCount(String submissionId) async {
    try {
      await _firestore
          .collection('submissions')
          .doc(submissionId)
          .update({'commentCount': FieldValue.increment(1)});
    } catch (e) {
      log('Failed to increment comment count: $e');
    }
  }

  @override
  Future<Either> updateComment(UpdateCommentReq updateCommentReq) async {
    bool isAdd = updateCommentReq.commentId == null;

    final dataMap = updateCommentReq.toMap();

    if (dataMap.keys.length == 1) {
      return const Left("Invalid data");
    }

    final commentId = updateCommentReq.commentId ??
        _firestore.collection('comments').doc().id;

    dataMap['commentId'] = commentId;

    if (isAdd) {
      dataMap['createdAt'] = Timestamp.now();
      await incrementCommentCount(updateCommentReq.submissionId);
    }

    try {
      await _firestore
          .collection("submissions")
          .doc(updateCommentReq.submissionId)
          .collection('comments')
          .doc(commentId)
          .set(dataMap, SetOptions(merge: true));
      return Right(commentId);
    } catch (e) {
      return Left('Failed to update comment: ${e.toString()}');
    }
  }

  @override
  Future<Either> getCommentsBySubmission(String submissionId) async {
    try {
      final comments = await _firestore
          .collection('submissions')
          .doc(submissionId)
          .collection('comments')
          .get()
          .then((value) => value.docs.map((d) => d.data()).toList());
      return Right(comments);
    } catch (e) {
      return Left('Failed to get comments by submission: ${e.toString()}');
    }
  }

  @override
  Future<Either> getUsersByIds(List<String> userIds) async {
    var toBeFetched = userIds.toChunks(25);
    List<Map<String, dynamic>> users = [];
    try {
      for (var chunk in toBeFetched) {
        final chunkUsers = await _firestore
            .collection('users')
            .where('userId', whereIn: chunk)
            .get()
            .then((value) => value.docs.map((d) => d.data()).toList());
        users.addAll(chunkUsers);
      }
      return Right(users);
    } catch (e) {
      return Left('Failed to get challenges by groups: ${e.toString()}');
    }
  }

  @override
  Future<Either> getScoresByGroup(String groupId) async {
    try {
      final scores = await _firestore
          .collection('scores')
          .where('groupId', isEqualTo: groupId)
          .get()
          .then((value) => value.docs.map((d) => d.data()).toList());
      return Right(scores);
    } catch (e) {
      return Left('Failed to get scores by group: $e');
    }
  }

  @override
  Future<Either> getPreviousEndedChallenge(String groupId) async {
    try {
      return await _firestore
          .collection('challenges')
          .where('groupId', isEqualTo: groupId)
          .where('endsAt', isLessThan: Timestamp.now())
          .orderBy('endsAt', descending: true)
          .limit(1)
          .get()
          .then((value) {
        if (value.size == 0) {
          return const Right(null);
        }
        return Right(value.docs.first.data());
      });
    } catch (e) {
      return Left('Failed to get previous ended challenge: $e');
    }
  }

  @override
  Future<Either> editGroupUserArray(
      EditGroupUserArrayReq editGroupUserArrayReq) async {
    try {
      FieldValue fieldvalue =
          FieldValue.arrayUnion([editGroupUserArrayReq.userId]);
      switch (editGroupUserArrayReq.groupArrayAction) {
        case GroupArrayAction.add:
          fieldvalue = FieldValue.arrayUnion([editGroupUserArrayReq.userId]);
          break;
        case GroupArrayAction.remove:
          fieldvalue = FieldValue.arrayRemove([editGroupUserArrayReq.userId]);
          break;
        default:
          return const Left('Invalid group array action');
      }
      return await _firestore
          .collection('groups')
          .doc(editGroupUserArrayReq.groupId)
          .update({editGroupUserArrayReq.groupUserArray.name: fieldvalue}).then(
              (value) => const Right('User added to group'));
    } catch (e) {
      return Left('Failed to add user to group: ${e.toString()}');
    }
  }

  @override
  Future<Either> updateFcmToken(String token) async {
    if (_currentUserId() == null) {
      return const Left('User not found');
    }
    final dataMap = {
      'userId': _currentUserId(),
      'token': token,
      'createdAt': Timestamp.now()
    };
    try {
      return await _firestore
          .collection('fcmTokens')
          .doc(_currentUserId())
          .set(dataMap, SetOptions(merge: true))
          .then((value) => const Right('Fcm token updated'));
    } catch (e) {
      return Left('Failed to update fcm token: ${e.toString()}');
    }
  }

  @override
  Future<Either> deleteSubmission(String submissionId) async {
    try {
      await _firestore.collection('submissions').doc(submissionId).delete();
      return const Right('Submission deleted');
    } catch (e) {
      return Left('Failed to delete submission: ${e.toString()}');
    }
  }

  @override
  Future<Either> getChallengeListener(String challengeId) async {
    try {
      return Right(
          _firestore.collection('challenges').doc(challengeId).snapshots());
    } catch (e) {
      return Left('Failed to get challenge listener: $e');
    }
  }
}
