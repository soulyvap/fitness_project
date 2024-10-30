import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/data/db/models/get_scores_by_challenge_and_user_req.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class GetScoresByChallengeAndUserUseCase
    extends UseCase<Either, GetScoresByChallengeAndUserReq> {
  @override
  Future<Either> call({GetScoresByChallengeAndUserReq? params}) async {
    return await sl<DBRepository>().getScoresByChallengeAndUser(params!);
  }
}
