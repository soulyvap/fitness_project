import 'package:fitness_project/data/repository/auth_repository_impl.dart';
import 'package:fitness_project/data/repository/db_repository_impl.dart';
import 'package:fitness_project/data/repository/storage_repository_impl.dart';
import 'package:fitness_project/data/source/auth_firebase_service.dart';
import 'package:fitness_project/data/source/firestore_firebase_service.dart';
import 'package:fitness_project/data/source/storage_firebase_service.dart';
import 'package:fitness_project/domain/repository/auth.dart';
import 'package:fitness_project/domain/repository/db.dart';
import 'package:fitness_project/domain/repository/storage.dart';
import 'package:fitness_project/domain/usecases/auth/get_user.dart';
import 'package:fitness_project/domain/usecases/auth/logout.dart';
import 'package:fitness_project/domain/usecases/db/add_group_member.dart';
import 'package:fitness_project/domain/usecases/db/get_users_by_display_name.dart';
import 'package:fitness_project/domain/usecases/db/update_group.dart';
import 'package:fitness_project/domain/usecases/db/update_user.dart';
import 'package:fitness_project/domain/usecases/storage/upload_file.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services

  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<StorageFirebaseService>(StorageFirebaseServiceImpl());
  sl.registerSingleton<FirestoreFirebaseService>(
      FirestoreFirebaseServiceImpl());

  // Repositories

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<StorageRepository>(StorageRepositoryImpl());
  sl.registerSingleton<DBRepository>(DBRepositoryImpl());

  // Usecases

  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());
  sl.registerSingleton<UpdateUserUseCase>(UpdateUserUseCase());
  sl.registerSingleton<UpdateGroupUseCase>(UpdateGroupUseCase());
  sl.registerSingleton<GetUsersByDisplayNameUseCase>(
      GetUsersByDisplayNameUseCase());
  sl.registerSingleton<AddGroupMemberUseCase>(AddGroupMemberUseCase());
  sl.registerSingleton<UploadFileUseCase>(UploadFileUseCase());
}
