import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either> logout();

  getUser(String s) {}
}
