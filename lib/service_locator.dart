import 'package:fitness_project/data/repository/auth_repository_impl.dart';
import 'package:fitness_project/data/repository/storage_repository_impl.dart';
import 'package:fitness_project/data/source/auth_firebase_service.dart';
import 'package:fitness_project/data/source/storage_firebase_service.dart';
import 'package:fitness_project/domain/repository/auth/auth.dart';
import 'package:fitness_project/domain/repository/storage/storage.dart';
import 'package:fitness_project/domain/usecases/auth/get_user.dart';
import 'package:fitness_project/domain/usecases/auth/logout.dart';
import 'package:fitness_project/domain/usecases/auth/update_user.dart';
import 'package:fitness_project/domain/usecases/storage/upload_file.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  // Services

  sl.registerSingleton<AuthFirebaseService>(AuthFirebaseServiceImpl());
  sl.registerSingleton<StorageFirebaseService>(StorageFirebaseServiceImpl());

  // Repositories

  sl.registerSingleton<AuthRepository>(AuthRepositoryImpl());
  sl.registerSingleton<StorageRepository>(StorageRepositoryImpl());

  // Usecases

  sl.registerSingleton<GetUserUseCase>(GetUserUseCase());
  sl.registerSingleton<LogoutUseCase>(LogoutUseCase());
  sl.registerSingleton<UpdateUserUseCase>(UpdateUserUseCase());
  sl.registerSingleton<UploadFileUseCase>(UploadFileUseCase());
}
