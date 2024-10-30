import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class GetSubmissionsByGroupsUseCase extends UseCase<Either, List<String>> {
  @override
  Future<Either> call({List<String>? params}) async {
    return await sl<DBRepository>().getSubmissionsByGroups(params!);
  }
}
