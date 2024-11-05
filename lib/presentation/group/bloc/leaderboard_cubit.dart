import 'package:fitness_project/domain/entities/db/challenge.dart';
import 'package:fitness_project/domain/entities/db/group.dart';
import 'package:fitness_project/domain/entities/db/score.dart';
import 'package:fitness_project/domain/entities/db/user.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/domain/usecases/db/get_scores_by_group.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LeaderboardItem {
  final UserEntity user;
  final int totalScore;
  final int position;
  final int? previousPosition;

  LeaderboardItem({
    required this.user,
    required this.totalScore,
    required this.position,
    this.previousPosition,
  });
}

abstract class LeaderboardState {}

class LeaderboardInitial extends LeaderboardState {}

class LeaderboardLoading extends LeaderboardState {}

class LeaderboardLoaded extends LeaderboardState {
  final List<LeaderboardItem> leaderboard;
  final List<ScoreEntity> scores;

  LeaderboardLoaded({
    required this.leaderboard,
    required this.scores,
  });
}

class LeaderboardError extends LeaderboardState {
  final String errorMessage;

  LeaderboardError(this.errorMessage);
}

class LeaderboardCubit extends Cubit<LeaderboardState> {
  final String groupId;
  LeaderboardCubit({
    required this.groupId,
  }) : super(LeaderboardInitial());

  Future<void> loadData() async {
    emit(LeaderboardLoading());
    try {
      final group = await _fetchGroup();
      if (group == null) {
        return;
      }
      final previousChallenge = await _fetchPreviousChallenge();
      final users = await _fetchUsers(group.members);
      if (users == null) {
        return;
      }
      final scores = await _fetchScores();
      if (scores == null) {
        return;
      }

      final List<ScoreEntity> previousScores = previousChallenge == null
          ? []
          : scores
              .where((score) =>
                  score.challengeId == previousChallenge.challengeId ||
                  score.createdAt.isBefore(previousChallenge.endsAt))
              .toList();

      final leaderboard = _createLeaderboard(users, scores, previousScores);

      emit(LeaderboardLoaded(leaderboard: leaderboard, scores: scores));
    } catch (e) {
      emit(LeaderboardError(e.toString()));
    }
  }

  int _calculateTotalScore(List<ScoreEntity> scores, String userId) {
    return scores
        .where((score) => score.userId == userId)
        .map((score) => score.points)
        .fold(0, (a, b) => a + b);
  }

  List<(String, int, int)> _calculatePositions(
      List<ScoreEntity> scores, List<String> userIds) {
    final List<(String, int)> userScores = [];
    for (final id in userIds) {
      final totalScore = _calculateTotalScore(scores, id);
      userScores.add((id, totalScore));
    }
    userScores.sort((a, b) => b.$2.compareTo(a.$2));
    final orderedUserIds = userScores.map((e) => e.$1).toList();
    final List<(String, int, int)> positions = [];
    for (final score in userScores) {
      if (positions.isEmpty) {
        positions.add((score.$1, score.$2, 1));
      } else {
        final previousPosition = positions.last.$3;
        final previousScore = positions.last.$2;
        final position = score.$2 == previousScore
            ? previousPosition
            : orderedUserIds.indexOf(score.$1) + 1;
        positions.add((score.$1, score.$2, position));
      }
    }
    return positions;
  }

  List<LeaderboardItem> _createLeaderboard(List<UserEntity> users,
      List<ScoreEntity> scores, List<ScoreEntity> previousScores) {
    final userIds = users.map((user) => user.userId).toList();
    final positions = _calculatePositions(scores, userIds);
    final noPreviousScores = previousScores.isEmpty;
    final previousPositions = _calculatePositions(previousScores, userIds);
    return positions.map((position) {
      final user = users.firstWhere((user) => user.userId == position.$1);
      final previousPosition = noPreviousScores
          ? null
          : previousPositions.firstWhere((e) => e.$1 == position.$1).$3;
      return LeaderboardItem(
        user: user,
        totalScore: position.$2,
        position: position.$3,
        previousPosition: previousPosition,
      );
    }).toList();
  }

  Future<GroupEntity?> _fetchGroup() async {
    final group = await sl<DBRepository>().getGroupById(groupId);

    GroupEntity? groupEntity;

    group.fold(
      (l) => emit(LeaderboardError(l.toString())),
      (r) => groupEntity = r,
    );

    return groupEntity;
  }

  Future<List<UserEntity>?> _fetchUsers(List<String> userIds) async {
    final users = await sl<DBRepository>().getUsersByIds(userIds);

    List<UserEntity> userEntities = [];

    users.fold(
      (l) => emit(LeaderboardError(l.toString())),
      (r) => userEntities = r,
    );

    return userEntities;
  }

  Future<List<ScoreEntity>?> _fetchScores() async {
    final scores = await sl<GetScoresByGroupUseCase>().call(params: groupId);

    List<ScoreEntity> scoreEntities = [];

    scores.fold(
      (l) => emit(LeaderboardError(l.toString())),
      (r) => scoreEntities = r,
    );

    return scoreEntities;
  }

  Future<ChallengeEntity?> _fetchPreviousChallenge() async {
    final challenge =
        await sl<DBRepository>().getPreviousEndedChallenge(groupId);

    ChallengeEntity? challengeEntity;

    challenge.fold(
      (l) => emit(LeaderboardError(l.toString())),
      (r) => challengeEntity = r,
    );

    return challengeEntity;
  }
}
