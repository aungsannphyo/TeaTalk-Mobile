import "package:flutter/material.dart";
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import "../presentation/screens/chat/private_chat_screen.dart";
import "../presentation/screens/friend/add_friend_screen.dart";
import "../presentation/screens/friend/friend_request_screen.dart";
import "../presentation/screens/friend/friends_screen.dart";
import "../presentation/screens/group/new_new_group_screen.dart";
import "../presentation/screens/user/profile.dart";
import "../presentation/screens/user/personal_details_screen.dart";
import "../presentation/screens/user/register_screen.dart";
import "../routes/routes_name.dart";
import "../presentation/providers/auth/login_provider.dart";
import "../presentation/screens/auth/login_screen.dart";
import "../presentation/screens/conversations/conversation_screen.dart";

// Helper for reusable custom transition page
CustomTransitionPage<T> buildTransitionPage<T>({
  required LocalKey key,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: key,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}

class GoRouterRefreshNotifier extends ChangeNotifier {
  GoRouterRefreshNotifier(Stream stream) {
    stream.listen((_) => notifyListeners());
  }
}

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(loginProvider);
  final isAuth = authState.isAuthenticated;

  return GoRouter(
    initialLocation: '/login',
    refreshListenable:
        GoRouterRefreshNotifier(ref.watch(loginProvider.notifier).stream),
    redirect: (context, state) {
      final goingToLogin = state.uri.toString() == '/login';
      final goingToRegister = state.uri.toString() == '/register';
      final isGoingToAuth = goingToLogin || goingToRegister;

      if (!isAuth && !isGoingToAuth) return '/login';
      if (isAuth && isGoingToAuth) return '/conversation';

      return null;
    },
    routes: [
      GoRoute(
        path: '/login',
        name: RouteName.login,
        pageBuilder: (context, state) => buildTransitionPage(
          key: state.pageKey,
          child: const LoginScreen(),
        ),
      ),
      GoRoute(
        path: '/register',
        name: RouteName.register,
        pageBuilder: (context, state) => buildTransitionPage(
          key: state.pageKey,
          child: const RegisterScreen(),
        ),
      ),
      GoRoute(
        path: '/conversation',
        name: RouteName.conversation,
        pageBuilder: (context, state) => buildTransitionPage(
          key: state.pageKey,
          child: const ConversationScreen(),
        ),
      ),
      GoRoute(
        path: '/add-friend',
        name: RouteName.addFriend,
        pageBuilder: (context, state) => buildTransitionPage(
          key: state.pageKey,
          child: const AddFriendScreen(),
        ),
      ),
      GoRoute(
        path: '/friend-request-log',
        name: RouteName.friendRequestLog,
        pageBuilder: (context, state) => buildTransitionPage(
          key: state.pageKey,
          child: const FriendRequestScreen(),
        ),
      ),
      GoRoute(
        path: '/friend',
        name: RouteName.friend,
        pageBuilder: (context, state) => buildTransitionPage(
          key: state.pageKey,
          child: const FriendsScreen(),
        ),
      ),
      GoRoute(
        path: '/profile',
        name: RouteName.profile,
        pageBuilder: (context, state) => buildTransitionPage(
          key: state.pageKey,
          child: const ProfileScreen(),
        ),
      ),
      GoRoute(
        path: '/chat',
        name: RouteName.chat,
        pageBuilder: (context, state) => buildTransitionPage(
          key: state.pageKey,
          child: PrivateChatScreen(
            key: state.pageKey,
            chatInfo: state.extra as Map<String, dynamic>?,
          ),
        ),
      ),
      GoRoute(
        path: '/new-group',
        name: RouteName.newGroup,
        pageBuilder: (context, state) => buildTransitionPage(
          key: state.pageKey,
          child: const NewGroupScreen(),
        ),
      ),
      GoRoute(
        path: '/personal-details',
        name: RouteName.personalDetails,
        pageBuilder: (context, state) => buildTransitionPage(
          key: state.pageKey,
          child: const PersonalDetailsScreen(),
        ),
      ),
    ],
  );
});
