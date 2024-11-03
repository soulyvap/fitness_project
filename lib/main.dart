import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_oauth_google/firebase_ui_oauth_google.dart';
import 'package:fitness_project/common/bloc/need_refresh_cubit.dart';
import 'package:fitness_project/common/bloc/user_cubit.dart';
import 'package:fitness_project/core/theme/app_theme.dart';
import 'package:fitness_project/presentation/auth/pages/Login.dart';
import 'package:fitness_project/presentation/home/bloc/home_data_cubit.dart';
import 'package:fitness_project/presentation/navigation/pages/navigation.dart';
import 'package:fitness_project/service_locator.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'firebase_options.dart';

void main() async {
  await dotenv.load(fileName: ".env");
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseUIAuth.configureProviders([
    GoogleProvider(clientId: dotenv.env['GOOGLE_CLIENT_ID'] as String),
  ]);
  await initializeDependencies();
  runApp(MultiBlocProvider(providers: [
    BlocProvider<UserCubit>(
      create: (context) => UserCubit(),
    ),
    BlocProvider<HomeDataCubit>(
      create: (context) => HomeDataCubit(),
    ),
    BlocProvider(create: (context) => NeedRefreshCubit()),
  ], child: const MyApp()));
}

final RouteObserver<ModalRoute> routeObserver = RouteObserver<ModalRoute>();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    if (FirebaseAuth.instance.currentUser != null) {
      context.read<UserCubit>().loadUser();
    }
    return MaterialApp(
      title: 'Fitness Project',
      theme: appTheme(),
      navigatorObservers: [routeObserver],
      home: FirebaseAuth.instance.currentUser == null
          ? const LoginPage()
          : const Navigation(),
    );
  }
}
