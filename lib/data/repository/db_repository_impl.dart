import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/models/db/add_group_member_req.dart';
import 'package:fitness_project/data/models/db/add_submission_seen_req.dart';
import 'package:fitness_project/data/models/db/challenge.dart';
import 'package:fitness_project/data/models/db/comment.dart';
import 'package:fitness_project/data/models/db/edit_group_user_array_req.dart';
import 'package:fitness_project/data/models/db/exercise.dart';
import 'package:fitness_project/data/models/db/get_challenges_by_groups_req.dart';
import 'package:fitness_project/data/models/db/get_groups_by_user_req.dart';
import 'package:fitness_project/data/models/db/get_scores_by_challenge_and_user_req.dart';
import 'package:fitness_project/data/models/db/get_submission_by_challenge_and_user_req.dart';
import 'package:fitness_project/data/models/db/group.dart';
import 'package:fitness_project/data/models/db/score.dart';
import 'package:fitness_project/data/models/db/submission.dart';
import 'package:fitness_project/data/models/db/update_challenge_req.dart';
import 'package:fitness_project/data/models/db/update_comment_req.dart';
import 'package:fitness_project/data/models/db/update_group_req.dart';
import 'package:fitness_project/data/models/db/update_like_req.dart';
import 'package:fitness_project/data/models/db/update_submission_req.dart';
import 'package:fitness_project/data/models/db/update_user_req.dart';
import 'package:fitness_project/data/models/db/user.dart';
import 'package:fitness_project/data/source/firestore_firebase_service.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class DBRepositoryImpl extends DBRepository {
  @override
  Future<Either> getUser(String? userId) async {
    var user = await sl<FirestoreFirebaseService>().getUser(userId);
    return user.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('User not found');
      }
      return Right(UserModel.fromMap(data).toEntity());
    });
  }

  @override
  Future<Either> updateUser(UpdateUserReq updateUserReq) {
    return sl<FirestoreFirebaseService>().updateUser(updateUserReq);
  }

  @override
  Future<Either> updateGroup(UpdateGroupReq updateGroupReq) {
    return sl<FirestoreFirebaseService>().updateGroup(updateGroupReq);
  }

  @override
  Future<Either> getUsersByDisplayName(String query) async {
    final users =
        await sl<FirestoreFirebaseService>().getUsersByDisplayName(query);
    return users.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Users not found');
      }
      final List<Map<String, dynamic>> users = data;
      final userEntities =
          users.map((e) => UserModel.fromMap(e).toEntity()).toList();
      return Right(userEntities);
    });
  }

  @override
  Future<Either> updateGroupMember(UpdateGroupMemberReq updateGroupMemberReq) {
    return sl<FirestoreFirebaseService>()
        .updateGroupMember(updateGroupMemberReq);
  }

  @override
  Future<Either> getGroupsByUser(GetGroupsByUserReq getGroupsByUserReq) async {
    final groups = await sl<FirestoreFirebaseService>()
        .getGroupsByUser(getGroupsByUserReq);
    return groups.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Groups not found');
      }
      final List<Map<String, dynamic>> groups = data;

      final groupEntities =
          groups.map((e) => GroupModel.fromMap(e).toEntity()).toList();
      return Right(groupEntities);
    });
  }

  @override
  Future<Either> getAllExercises() async {
    final exercises = await sl<FirestoreFirebaseService>().getAllExercises();
    return exercises.fold(
      (error) {
        return Left(error);
      },
      (data) {
        if (data == null) {
          return const Left('Exercises not found');
        }
        final List<Map<String, dynamic>> exercises = data;
        final exerciseEntities =
            exercises.map((e) => ExerciseModel.fromMap(e).toEntity()).toList();
        return Right(exerciseEntities);
      },
    );
  }

  @override
  Future<Either> updateChallenge(UpdateChallengeReq updateChallengeReq) {
    return sl<FirestoreFirebaseService>().updateChallenge(UpdateChallengeReq());
  }

  @override
  Future<Either> getChallengesByGroups(
      GetChallengesByGroupsReq getChallengesByGroupsReq) async {
    final challenges = await sl<FirestoreFirebaseService>()
        .getChallengesByGroups(getChallengesByGroupsReq);
    return challenges.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Challenges not found');
      }
      final List<Map<String, dynamic>> challenges = data;
      final challengeEntities =
          challenges.map((e) => ChallengeModel.fromMap(e).toEntity()).toList();
      return Right(challengeEntities);
    });
  }

  @override
  Future<Either> getExerciseById(String exerciseId) async {
    final exercise =
        await sl<FirestoreFirebaseService>().getExerciseById(exerciseId);
    return exercise.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Exercise not found');
      }
      final exerciseEntity = ExerciseModel.fromMap(data).toEntity();
      return Right(exerciseEntity);
    });
  }

  @override
  Future<Either> getChallengeById(String challengeId) async {
    final challenge =
        await sl<FirestoreFirebaseService>().getChallengeById(challengeId);
    return challenge.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Challenge not found');
      }
      final challengeEntity = ChallengeModel.fromMap(data).toEntity();
      return Right(challengeEntity);
    });
  }

  @override
  Future<Either> getGroupById(String groupId) async {
    final group = await sl<FirestoreFirebaseService>().getGroupById(groupId);
    return group.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Group not found');
      }
      final groupEntity = GroupModel.fromMap(data).toEntity();
      return Right(groupEntity);
    });
  }

  @override
  Future<Either> updateSubmission(
      UpdateSubmissionReq updateSubmissionReq) async {
    return sl<FirestoreFirebaseService>().updateSubmission(updateSubmissionReq);
  }

  @override
  Future<Either> getScoresBySubmission(String submissionId) async {
    try {
      final scores = await sl<FirestoreFirebaseService>()
          .getScoresBySubmission(submissionId);
      return scores.fold((error) {
        return Left(error);
      }, (data) {
        if (data == null) {
          return const Left('Scores not found');
        }
        final List<Map<String, dynamic>> scores = data;
        final scoreEntities =
            scores.map((e) => ScoreModel.fromMap(e).toEntity()).toList();
        return Right(scoreEntities);
      });
    } catch (e) {
      return Left(e.toString());
    }
  }

  @override
  Future<Either> getSubmissionByChallengeAndUser(
      GetSubmissionByChallengeAndUserReq
          getSubmissionByChallengeAndUserReq) async {
    final submission = await sl<FirestoreFirebaseService>()
        .getSubmissionByChallengeAndUser(getSubmissionByChallengeAndUserReq);
    return submission.fold(
      (error) {
        return Left(error);
      },
      (data) {
        if (data == null) {
          return const Left('Submission not found');
        }
        final submissionEntity = SubmissionModel.fromMap(data).toEntity();
        return Right(submissionEntity);
      },
    );
  }

  @override
  Future<Either> getSubmissionById(String submissionId) async {
    final submission =
        await sl<FirestoreFirebaseService>().getSubmissionById(submissionId);
    return submission.fold(
      (error) {
        return Left(error);
      },
      (data) {
        if (data == null) {
          return const Left('Submission not found');
        }
        final submissionEntity = SubmissionModel.fromMap(data).toEntity();
        return Right(submissionEntity);
      },
    );
  }

  @override
  Future<Either> getScoresByChallengeAndUser(
      GetScoresByChallengeAndUserReq getScoresByChallengeAndUserReq) async {
    final scores = await sl<FirestoreFirebaseService>()
        .getScoresByChallengeAndUser(getScoresByChallengeAndUserReq);

    return scores.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Scores not found');
      }
      final List<Map<String, dynamic>> scores = data;
      final scoreEntities =
          scores.map((e) => ScoreModel.fromMap(e).toEntity()).toList();
      return Right(scoreEntities);
    });
  }

  @override
  Future<Either> getSubmissionsByChallenge(String challengeId) async {
    final submissions = await sl<FirestoreFirebaseService>()
        .getSubmissionsByChallenge(challengeId);
    return submissions.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Submissions not found');
      }
      final List<Map<String, dynamic>> submissions = data;
      final submissionEntities = submissions
          .map((e) => SubmissionModel.fromMap(e).toEntity())
          .toList();
      submissionEntities.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(submissionEntities);
    });
  }

  @override
  Future<Either> getSubmissionsByGroups(List<String> groupIds) async {
    final submissions =
        await sl<FirestoreFirebaseService>().getSubmissionsByGroups(groupIds);
    return submissions.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Submissions not found');
      }
      final List<Map<String, dynamic>> submissions = data;
      final submissionEntities = submissions
          .map((e) => SubmissionModel.fromMap(e).toEntity())
          .toList();
      submissionEntities.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      return Right(submissionEntities);
    });
  }

  @override
  Future<Either> addSubmissionSeen(AddSubmissionSeenReq addSubmissionSeenReq) {
    return sl<FirestoreFirebaseService>()
        .addSubmissionSeen(addSubmissionSeenReq);
  }

  @override
  Future<Either> updateLike(UpdateLikeReq updateLikeReq) async {
    return sl<FirestoreFirebaseService>().updateLike(updateLikeReq);
  }

  @override
  Future<Either> updateComment(UpdateCommentReq updateCommentReq) async {
    return await sl<FirestoreFirebaseService>().updateComment(updateCommentReq);
  }

  @override
  Future<Either> getCommentsBySubmission(String submissionId) async {
    final comments = await sl<FirestoreFirebaseService>()
        .getCommentsBySubmission(submissionId);
    return comments.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Comments not found');
      }
      final List<Map<String, dynamic>> comments = data;
      final commentEntities =
          comments.map((e) => CommentModel.fromMap(e).toEntity()).toList();
      return Right(commentEntities);
    });
  }

  @override
  Future<Either> getUsersByIds(List<String> userIds) async {
    final users = await sl<FirestoreFirebaseService>().getUsersByIds(userIds);
    return users.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Users not found');
      }
      final List<Map<String, dynamic>> users = data;
      final userEntities =
          users.map((e) => UserModel.fromMap(e).toEntity()).toList();
      return Right(userEntities);
    });
  }

  @override
  Future<Either> getScoresByGroup(String groupId) async {
    final scores =
        await sl<FirestoreFirebaseService>().getScoresByGroup(groupId);
    return scores.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Scores not found');
      }
      final List<Map<String, dynamic>> scores = data;
      final scoreEntities =
          scores.map((e) => ScoreModel.fromMap(e).toEntity()).toList();
      return Right(scoreEntities);
    });
  }

  @override
  Future<Either> getPreviousEndedChallenge(String groupId) async {
    final challenge =
        await sl<FirestoreFirebaseService>().getPreviousEndedChallenge(groupId);
    return challenge.fold((error) {
      return Left(error);
    }, (data) {
      if (data == null) {
        return const Left('Challenge not found');
      }
      return Right(ChallengeModel.fromMap(data).toEntity());
    });
  }

  @override
  Future<Either> editGroupUserArray(
      EditGroupUserArrayReq editGroupUserArrayReq) async {
    return await sl<FirestoreFirebaseService>()
        .editGroupUserArray(editGroupUserArrayReq);
  }

  @override
  Future<Either> updateFcmToken(String token) async {
    return await sl<FirestoreFirebaseService>().updateFcmToken(token);
  }
}
