import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/data/db/models/get_groups_by_user_req.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class GetGroupsByUserUseCase extends UseCase<Either, GetGroupsByUserReq> {
  @override
  Future<Either> call({GetGroupsByUserReq? params}) async {
    return await sl<DBRepository>().getGroupsByUser(params!);
  }
}
