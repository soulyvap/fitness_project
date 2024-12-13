import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class GetChallengeListenerUseCase extends UseCase<Either, String> {
  @override
  Future<Either> call({String? params}) {
    return sl<DBRepository>().getChallengeListener(params!);
  }
}
