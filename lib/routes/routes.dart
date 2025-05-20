import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import "package:ywar_talk_mobile/presentation/navigation/botton_nav.dart";
import "package:ywar_talk_mobile/routes/routes_name.dart";
import "../presentation/providers/auth/auth_provider.dart";
import "../presentation/screens/auth/login_screen.dart";
import "../presentation/screens/conversations/conversation_screen.dart";
import "../presentation/screens/profile/profile.dart";

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    redirect: (context, state) {
      final isAuth = authState.isAuthenticated;

      final isGoingToLogin = state.uri.toString() == '/login';

      if (!isAuth && !isGoingToLogin) return '/login';
      if (isAuth && isGoingToLogin) return '/';

      return null;
    },
    routes: [
      GoRoute(
        name: RouteName.login,
        path: RoutePathName.login,
        builder: (context, state) => const LoginScreen(),
      ),
      GoRoute(
        name: RouteName.root,
        path: RoutePathName.root,
        builder: (context, state) => const BottonNavigation(),
      ),
      GoRoute(
        name: RouteName.conversation,
        path: RoutePathName.conversation,
        builder: (context, state) => const ConversationsScreen(),
      ),
      GoRoute(
        name: RouteName.user,
        path: RoutePathName.user,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
