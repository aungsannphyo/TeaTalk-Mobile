import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../routes/routes_name.dart';
import '../../providers/auth/login_provider.dart';
import '../../providers/conversation/conversation_provider.dart';
import '../../widgets/conversation/conversation_item_widget.dart';
import "../../../style/theme/app_color.dart";
import '../../widgets/conversation/conversation_pop_up_menu_widget.dart';
import '../../widgets/conversation/no_conversation_widget.dart';

class ConversationScreen extends HookConsumerWidget {
  const ConversationScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);
    final ConversationState conversationState = ref.watch(conversationProvider);

    useEffect(() {
      final userId = authState.auth?.id;
      if (userId != null) {
        Future.microtask(() {
          ref.read(conversationProvider.notifier).getConversations(userId);
        });
      }
      return null;
    }, [authState.auth]);

    void onMenuSelected(BuildContext context, String value) {
      switch (value) {
        case 'add_friend':
          GoRouter.of(context).pushNamed(RouteName.addFriend);
          break;
        case 'friends_list':
          break;
        case 'create_group':
          break;
      }
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
        title: Text(
          'Messages',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.8,
          ),
        ),
        actions: [
          ConversationPopUpMenuWidget(
            onMenuSelected: onMenuSelected,
          )
        ],
        centerTitle: true,
      ),
      body: conversationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : conversationState.conversationList == null ||
                  conversationState.conversationList!.isEmpty
              ? NoConversationWidget()
              : Column(
                  children: [
                    Expanded(
                      child: ListView.separated(
                        itemCount: conversationState.conversationList!.length,
                        separatorBuilder: (_, __) =>
                            Divider(height: 10, color: AppColors.bubbleShadow),
                        itemBuilder: (context, index) {
                          return ConversationItemWidget(
                              conversation:
                                  conversationState.conversationList![index]);
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
