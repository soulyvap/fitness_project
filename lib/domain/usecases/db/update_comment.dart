import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/data/models/db/update_comment_req.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class UpdateCommentUseCase extends UseCase<Either, UpdateCommentReq> {
  @override
  Future<Either> call({UpdateCommentReq? params}) async {
    return await sl<DBRepository>().updateComment(params!);
  }
}
