import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "../../presentation/navigation/botton_nav.dart";
import "../../presentation/screens/auth/register_screen.dart";
import "../routes/routes_name.dart";
import "../presentation/providers/auth/auth_provider.dart";
import "../presentation/screens/auth/login_screen.dart";
import "../presentation/screens/conversations/conversation_screen.dart";
import "../presentation/screens/profile/profile.dart";

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Stream stream) {
    stream.listen((_) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);
  final isAuth = authState.isAuthenticated;

  return GoRouter(
    initialLocation: '/login',
    refreshListenable:
        GoRouterRefreshNotifier(ref.watch(authProvider.notifier).stream),
    redirect: (context, state) {
      final goingToLogin = state.uri.toString() == '/login';
      final goingToRegister = state.uri.toString() == '/register';
      final isGoingToAuth = goingToLogin || goingToRegister;

      if (!isAuth && !isGoingToAuth) return '/login';
      if (isAuth && isGoingToAuth) return '/';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: RouteName.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        path: '/register',
        name: RouteName.register,
        builder: (context, state) => const RegisterScreen(),
      ),
      GoRoute(
        path: '/',
        name: RouteName.root,
        builder: (context, state) => const BottonNavigation(),
      ),
      GoRoute(
        path: '/conversation',
        name: RouteName.conversation,
        builder: (context, state) => const ConversationsScreen(),
      ),
      GoRoute(
        path: '/user',
        name: RouteName.user,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
