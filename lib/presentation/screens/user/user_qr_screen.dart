import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';

import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';
import '../../providers/user/get_user_provider.dart';
import '../../widgets/common_avatar_widget.dart';
import '../../widgets/common_button_widget.dart';

class UserQrScreen extends HookConsumerWidget {
  const UserQrScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final UserState userState = ref.watch(getUserProvider);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        child: Align(
          alignment: Alignment.topCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 50, bottom: 24),
                child: Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.topCenter,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        color: AppColors.complementary,
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withAlpha((255 * 0.1).round()),
                            blurRadius: 6,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      padding: const EdgeInsets.only(
                        top: 70,
                        left: 30,
                        right: 30,
                        bottom: 40, // reduced bottom padding to fit text nicely
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          QrImageView(
                            data: userState.user != null
                                ? userState.user!.userIdentity
                                : '',
                            version: QrVersions.auto,
                            size: 200,
                            backgroundColor: AppColors.complementary,
                            eyeStyle: QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: AppColors.background,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: AppColors.background,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            userState.user != null
                                ? userState.user!.userIdentity
                                : '',
                            style: AppTextStyles.semiBold.copyWith(
                              color: AppColors.background,
                              fontSize: 20,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      top: -40,
                      child: CommonAvatarWidget(
                        radius: 40,
                        username: userState.user != null
                            ? userState.user!.userIdentity
                            : '',
                        profileImage: userState.details != null
                            ? userState.details!.profileImage
                            : '',
                      ),
                    ),
                  ],
                ),
              ),
              Text(
                userState.user != null ? userState.user!.userIdentity : '',
                style: AppTextStyles.semiBold.copyWith(
                  color: AppColors.background,
                  fontSize: 20,
                ),
              ),
              const SizedBox(height: 24),
              CommonButtonWidget(
                isLoading: false,
                label: "Save",
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
