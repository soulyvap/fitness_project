import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class AddGroupMemberUseCase extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({dynamic params}) async {
    return sl<DBRepository>().addGroupMember(params);
  }
}
