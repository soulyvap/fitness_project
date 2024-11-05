import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class GetUsersByIdsUseCase extends UseCase<Either, List<String>> {
  @override
  Future<Either> call({List<String>? params}) async {
    return sl<DBRepository>().getUsersByIds(params!);
  }
}
