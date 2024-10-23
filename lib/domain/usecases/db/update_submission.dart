import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/data/db/models/update_submission_req.dart';
import 'package:fitness_project/data/source/firestore_firebase_service.dart';
import 'package:fitness_project/service_locator.dart';

class UpdateSubmissionUseCase extends UseCase<Either, UpdateSubmissionReq> {
  @override
  Future<Either> call({UpdateSubmissionReq? params}) async {
    return await sl<FirestoreFirebaseService>().updateSubmission(params!);
  }
}
