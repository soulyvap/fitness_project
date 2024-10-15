import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/domain/repository/auth.dart';
import 'package:fitness_project/service_locator.dart';

class LogoutUseCase extends UseCase<Either, dynamic> {
  @override
  Future<Either> call({params}) {
    return sl<AuthRepository>().logout();
  }
}
