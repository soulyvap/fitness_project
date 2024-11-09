import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/data/models/db/edit_group_user_array_req.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class EditGroupUserArrayUseCase extends UseCase<Either, EditGroupUserArrayReq> {
  @override
  Future<Either> call({EditGroupUserArrayReq? params}) async {
    return sl<DBRepository>().editGroupUserArray(params!);
  }
}
