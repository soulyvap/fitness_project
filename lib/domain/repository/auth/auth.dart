import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either> getUser();
  Future<Either> logout();
}
