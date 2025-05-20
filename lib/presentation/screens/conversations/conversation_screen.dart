import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../../presentation/providers/auth/auth_provider.dart';
import '../../providers/conversation/conversation_provider.dart';
import '../../widgets/conversation/conversation_item_widget.dart';
import "../../../style/theme/color.dart";

class ConversationsScreen extends HookConsumerWidget {
  const ConversationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AuthState authState = ref.watch(authProvider);
    final ConversationState conversationState = ref.watch(conversationProvider);

    useEffect(() {
      if (authState.auth != null) {
        Future.microtask(() {
          ref
              .read(conversationProvider.notifier)
              .getConversations(authState.auth!.id);
        });
      }
      return null;
    }, [authState.auth]);

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
        centerTitle: true,
      ),
      body: conversationState.isLoading
          ? const Center(child: CircularProgressIndicator())
          : conversationState.conversationList == null ||
                  conversationState.conversationList!.isEmpty
              ? const Center(child: Text("No conversations found."))
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
