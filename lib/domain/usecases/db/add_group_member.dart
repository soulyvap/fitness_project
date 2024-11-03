import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/data/models/db/add_group_member_req.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class UpdateGroupMemberUseCase extends UseCase<Either, UpdateGroupMemberReq> {
  @override
  Future<Either> call({UpdateGroupMemberReq? params}) async {
    return await sl<DBRepository>().updateGroupMember(params!);
  }
}
