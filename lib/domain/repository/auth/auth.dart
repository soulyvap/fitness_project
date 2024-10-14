import 'package:dartz/dartz.dart';
import 'package:fitness_project/data/auth/models/update_user_req.dart';

abstract class AuthRepository {
  Future<Either> getUser();
  Future<Either> logout();
  Future<Either> updateUser(UpdateUserReq updateUserReq);
}
