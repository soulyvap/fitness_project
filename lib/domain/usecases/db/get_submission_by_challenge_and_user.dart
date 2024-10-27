import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/data/db/models/get_submission_by_challenge_and_user_req.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class GetSubmissionByChallengeAndUserUserCase
    extends UseCase<Either, GetSubmissionByChallengeAndUserReq> {
  @override
  Future<Either> call({GetSubmissionByChallengeAndUserReq? params}) async {
    return await sl<DBRepository>().getSubmissionByChallengeAndUser(params!);
  }
}
