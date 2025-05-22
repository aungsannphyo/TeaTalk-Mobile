import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import "../presentation/screens/chat/chat_screen.dart";
import "../presentation/screens/friend/add_friend_screen.dart";
import "../presentation/screens/friend/friend_request_screen.dart";
import "../presentation/screens/friend/friends_screen.dart";
import "../presentation/screens/user/profile.dart";
import "../presentation/screens/user/register_screen.dart";
import "../routes/routes_name.dart";
import "../presentation/providers/auth/login_provider.dart";
import "../presentation/screens/auth/login_screen.dart";
import "../presentation/screens/conversations/conversation_screen.dart";

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
        builder: (context, state) => const ConversationScreen(),
      ),
      GoRoute(
        path: '/conversation',
        name: RouteName.conversation,
        builder: (context, state) => const ConversationScreen(),
      ),
      GoRoute(
        path: '/add-friend',
        name: RouteName.addFriend,
        builder: (context, state) => const AddFriendScreen(),
      ),
      GoRoute(
        path: '/friend-request-log',
        name: RouteName.friendRequestLog,
        builder: (context, state) => const FriendRequestScreen(),
      ),
      GoRoute(
        path: '/friend',
        name: RouteName.friend,
        builder: (context, state) => const FriendsScreen(),
      ),
      GoRoute(
        path: '/profile',
        name: RouteName.profile,
        builder: (context, state) => const ProfileScreen(),
      ),
      GoRoute(
        path: '/chat',
        name: RouteName.chat,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>?;
          return ChatScreen(
            key: state.pageKey,
            friendInfo: extra,
          );
        },
      ),
    ],
  );
});
