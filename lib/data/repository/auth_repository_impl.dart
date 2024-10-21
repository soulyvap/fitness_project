import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/source/auth_firebase_service.dart';
import 'package:fitness_project/domain/repository/auth.dart';
import 'package:fitness_project/service_locator.dart';

class AuthRepositoryImpl extends AuthRepository {
  @override
  Future<Either> logout() async {
    var logout = await sl<AuthFirebaseService>().logout();
    return logout.fold((error) {
      return Left(error);
    }, (data) {
      return Right(data);
    });
  }
}
