import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fitness_project/data/auth/models/update_user_req.dart';

abstract class AuthFirebaseService {
  Future<Either> getUser();
  Future<Either> logout();
  Future<Either> updateUser(UpdateUserReq updateUserReq);
}

class AuthFirebaseServiceImpl extends AuthFirebaseService {
  @override
  Future<Either> getUser() async {
    try {
      var currentUser = FirebaseAuth.instance.currentUser;
      var userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(currentUser?.uid)
          .get()
          .then((value) => value.data());
      return Right(userData);
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> logout() async {
    try {
      await FirebaseAuth.instance.signOut();
      return const Right('Logged out');
    } catch (e) {
      return const Left('Please try again');
    }
  }

  @override
  Future<Either> updateUser(UpdateUserReq updateUserReq) async {
    if (updateUserReq.image == null &&
        updateUserReq.displayName == null &&
        updateUserReq.image == null) {
      return const Left("Invalid data");
    }
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(updateUserReq.userId)
          .set(updateUserReq.toMap(), SetOptions(merge: true));
      return const Right('User updated');
    } catch (e) {
      return const Left('Please try again');
    }
  }
}
