import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

abstract class AuthFirebaseService {
  Future<Either> logout();
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return const Right('Logged out');
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
