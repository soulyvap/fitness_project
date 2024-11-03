import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/data/models/db/update_challenge_req.dart';
import 'package:fitness_project/data/source/firestore_firebase_service.dart';
import 'package:fitness_project/service_locator.dart';

class UpdateChallengeUseCase extends UseCase<Either, UpdateChallengeReq> {
  @override
  Future<Either> call({UpdateChallengeReq? params}) async {
    return await sl<FirestoreFirebaseService>().updateChallenge(params!);
  }
}
