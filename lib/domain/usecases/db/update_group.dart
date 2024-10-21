import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/data/db/models/update_group_req.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class UpdateGroupUseCase extends UseCase<Either, UpdateGroupReq> {
  @override
  Future<Either> call({UpdateGroupReq? params}) async {
    return await sl<DBRepository>().updateGroup(params!);
  }
}
