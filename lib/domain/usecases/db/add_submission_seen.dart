import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/data/db/models/add_submission_seen_req.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class AddSubmissionSeenUseCase extends UseCase<Either, AddSubmissionSeenReq> {
  @override
  Future<Either> call({AddSubmissionSeenReq? params}) async {
    return await sl<DBRepository>().addSubmissionSeen(params!);
  }
}
