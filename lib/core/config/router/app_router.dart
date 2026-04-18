import 'dart:async';
import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:hive/hive.dart';

import '../../../features/auth/presentation/screens/login_screen.dart';
import '../../../features/auth/presentation/screens/register_screen.dart';
import '../../../features/home/presentation/screens/home_screen.dart';
import '../../../features/splashscreen/presentation/screen/splash_screen.dart';

class Routes {
  Routes._();
  static const splash = '/splash';

  static const login = '/login';
  static const signup = '/signup';
}

class AppRouter {
  AppRouter._();

  static final routeObserver = RouteObserver<ModalRoute<void>>();

  static final GlobalKey<NavigatorState> rootNavigatorKey =
      GlobalKey<NavigatorState>();
  static final GlobalKey<NavigatorState> shellNavigatorKey =
      GlobalKey<NavigatorState>();

 

  static final router = GoRouter(
    navigatorKey: rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: kDebugMode,

    refreshListenable: GoRouterRefreshStream(
      FirebaseAuth.instance.authStateChanges(),
    ),

    redirect: (context, state) {
      final box = Hive.box('appBox');
  final isFirstTime = box.get('isFirstTime', defaultValue: true);
      final user = FirebaseAuth.instance.currentUser;
final isSplash = state.matchedLocation == Routes.splash;
      final isLoggingIn =
          state.matchedLocation == Routes.login ||
          state.matchedLocation == Routes.signup;

           /// ✅ FIRST TIME → show splash
  if (isFirstTime) {
    if (!isSplash) return Routes.splash;

    // mark as visited AFTER entering splash
    Future.microtask(() => box.put('isFirstTime', false));
    return null;
  }

      // ❌ Not logged in
      if (user == null) {
        return isLoggingIn ? null : Routes.login;
      }

      // ✅ Logged in
      if (isLoggingIn) {
        return '/home';
      }

      return null;
    },

    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (context, state) => const SplashScreen(),
      ),

      GoRoute(
        path: Routes.login,
        builder: (context, state) => const LoginScreen(),
      ),

      GoRoute(
        path: Routes.signup,
        builder: (context, state) => const SignupScreen(),
      ),

      GoRoute(
        path: '/home',
        builder: (context, state) => const HomeScreen(firebaseReady: true),
      ),
    ],
  );

  // PLATFORM AWARE PAGE BUILDER
  static CustomTransitionPage _platformTransitionPage({
    required GoRouterState state,
    required Widget child,
  }) {
    if (Platform.isIOS) {
      return _cupertinoPage(state: state, child: child);
    } else {
      return _fadePage(state: state, child: child);
    }
  }

  /// --- Custom Page Transitions ---

  static CustomTransitionPage _fadePage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static CustomTransitionPage _slidePage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final tween = Tween(
          begin: const Offset(1, 0),
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeInOut));
        return SlideTransition(position: animation.drive(tween), child: child);
      },
    );
  }

  static CustomTransitionPage _bottomToTopSlidePage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 400),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        // Slide from bottom
        final slideAnimation = Tween<Offset>(
          begin: const Offset(0, 0.25), // small offset, not full screen
          end: Offset.zero,
        ).chain(CurveTween(curve: Curves.easeOutCubic)).animate(animation);

        // Slight scale
        final scaleAnimation = Tween<double>(
          begin: 0.97,
          end: 1.0,
        ).chain(CurveTween(curve: Curves.easeOutBack)).animate(animation);

        // Fade
        final fadeAnimation = Tween<double>(
          begin: 0.0,
          end: 1.0,
        ).animate(CurvedAnimation(parent: animation, curve: Curves.easeIn));

        return SlideTransition(
          position: slideAnimation,
          child: ScaleTransition(
            scale: scaleAnimation,
            child: FadeTransition(opacity: fadeAnimation, child: child),
          ),
        );
      },
    );
  }

  static CustomTransitionPage _cupertinoPage({
    required GoRouterState state,
    required Widget child,
  }) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position: Tween(
            begin: const Offset(1, 0),
            end: Offset.zero,
          ).animate(animation),
          child: child,
        );
      },
    );
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  late final StreamSubscription _subscription;

  GoRouterRefreshStream(Stream<dynamic> stream) {
    _subscription = stream.asBroadcastStream().listen((_) {
      notifyListeners();
    });
  }

  @override
  void dispose() {
    _subscription.cancel();
    super.dispose();
  }
}
