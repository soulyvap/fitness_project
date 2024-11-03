import 'package:dartz/dartz.dart';
import 'package:fitness_project/core/usecase/usecase.dart';
import 'package:fitness_project/data/models/db/update_like_req.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/service_locator.dart';

class UpdateLikeUseCase extends UseCase<Either, UpdateLikeReq> {
  @override
  Future<Either> call({UpdateLikeReq? params}) async {
    return await sl<DBRepository>().updateLike(params!);
  }
}
