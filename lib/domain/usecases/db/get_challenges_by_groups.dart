import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/data/models/db/get_challenges_by_groups_req.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class GetChallengesByGroupsUseCase
    extends UseCase<Either, GetChallengesByGroupsReq> {
  @override
  Future<Either> call({GetChallengesByGroupsReq? params}) async {
    return await sl<DBRepository>().getChallengesByGroups(params!);
  }
}
