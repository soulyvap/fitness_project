import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:fitness_project/common/bloc/need_refresh_cubit.dart';
import 'package:fitness_project/common/bloc/user_cubit.dart';
import 'package:fitness_project/core/classes/notification_service.dart';
import 'package:fitness_project/core/classes/permission_request_service.dart';
import 'package:fitness_project/main.dart';
import 'package:fitness_project/presentation/create_account/pages/create_account.dart';
import 'package:fitness_project/presentation/home/bloc/home_data_cubit.dart';
import 'package:fitness_project/presentation/navigation/widgets/bottom_bar.dart';
import 'package:fitness_project/presentation/navigation/bloc/nav_index_cubit.dart';
import 'package:fitness_project/presentation/start/pages/permissions.dart';
import 'package:fitness_project/presentation/start/pages/login.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../home/pages/home.dart';

class Navigation extends StatefulWidget {
  final int? initialIndex;
  const Navigation({super.key, this.initialIndex});

  @override
  State<Navigation> createState() => _NavigationState();
}

class _NavigationState extends State<Navigation> with RouteAware {
  late StreamSubscription<RemoteMessage> _notifSub;

  @override
  void initState() {
    checkPermissions().then((value) {
      if (FirebaseAuth.instance.currentUser != null) {
        NotificationService.initNotifications().then((val) {
          _notifSub =
              FirebaseMessaging.onMessage.listen((RemoteMessage message) {
            final isChallengeMessage = message.data['type'] == 'challenge';
            if (isChallengeMessage) {
              refreshHomePage();
            }
          });
        });
      }
    });
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(this, ModalRoute.of(context)!);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    _notifSub.cancel();
    super.dispose();
  }

  @override
  void didPopNext() {
    final needsRefresh = context.read<NeedRefreshCubit>().state;
    if (needsRefresh) {
      refreshHomePage();
      context.read<NeedRefreshCubit>().setValue(false);
    }
    super.didPopNext();
  }

  void refreshHomePage() {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) {
      return;
    }
    debugPrint("Refreshing home page");
    context.read<HomeDataCubit>().loadData(userId);
  }

  Future<void> checkPermissions() async {
    final notificationPermission =
        await PermissionRequestService().hasNotificationPermission();
    final cameraPermission =
        await PermissionRequestService().hasCameraPermission();
    if (notificationPermission == false || cameraPermission == false) {
      navigatorKey.currentState
          ?.pushReplacement(MaterialPageRoute(builder: (context) {
        return const PermissionsPage();
      }));
      return;
    }
    loadData();
  }

  void loadData() {
    final userState = context.read<UserCubit>().state;
    if (userState is UserLoaded) {
      refreshHomePage();
    } else {
      context
          .read<UserCubit>()
          .loadUser(FirebaseAuth.instance.currentUser!.uid)
          .then((value) => refreshHomePage());
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserCubit, UserState>(builder: (context, userState) {
      final authUser = FirebaseAuth.instance.currentUser;
      if (authUser == null) {
        return const LoginPage();
      } else if (userState is UserLoading) {
        return const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        );
      } else if (userState is UserNotFound) {
        return CreateAccountPage(
            userId: authUser.uid, userEmail: authUser.email ?? "no email");
      } else if (userState is UserLoaded) {
        return BlocProvider(
            create: (context) => NavIndexCubit(widget.initialIndex ?? 0),
            child: BlocBuilder<NavIndexCubit, int>(
              builder: (context, state) {
                return Scaffold(
                  extendBody: true,
                  body: IndexedStack(
                    index: state,
                    children: [
                      HomePage(currentUser: userState.user),
                      const Center(
                        child: Text("Find Page"),
                      ),
                      const Center(
                        child: Text("Alerts Page"),
                      ),
                    ],
                  ),
                  bottomNavigationBar: BottomBar(
                    navIndex: state,
                    setIndex: (index) =>
                        context.read<NavIndexCubit>().setIndex(index),
                    hasAGroup: context.watch<HomeDataCubit>().state
                            is HomeDataLoaded &&
                        (context.read<HomeDataCubit>().state as HomeDataLoaded)
                            .myGroups
                            .where(
                                (group) => group.members.contains(authUser.uid))
                            .isNotEmpty,
                  ),
                );
              },
            ));
      } else if (userState is UserError) {
        return Center(
          child: Text(userState.errorMessage),
        );
      } else {
        return const SizedBox();
      }
    });
  }
}
