import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

import '../../../../style/theme/app_color.dart';
import '../../friend/widget/avatar_widget.dart';

class ProfileAvatarWidget extends HookConsumerWidget {
  const ProfileAvatarWidget({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final picker = useMemoized(() => ImagePicker());

    return Stack(
      children: [
        Container(
          height: 100,
          width: 100,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(60),
          ),
          child: const AvatarWidget(
            username: "Charlotte King",
            radius: 50,
          ),
        ),
        Positioned(
          bottom: 4,
          right: 4,
          child: GestureDetector(
            onTap: () async {
              final pickedFile = await showModalBottomSheet<XFile?>(
                context: context,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                ),
                backgroundColor: Colors.white,
                builder: (ctx) {
                  return SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 12),
                          child: Text(
                            'Select Image Source',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ListTile(
                          leading: const Icon(Icons.camera_alt),
                          title: const Text('Take a photo'),
                          onTap: () async {
                            await Future.delayed(const Duration(seconds: 1));
                            final picked = await picker.pickImage(
                                source: ImageSource.camera);
                            if (context.mounted) {
                              Navigator.of(context).pop(picked);
                            }
                          },
                        ),
                        ListTile(
                          leading: const Icon(Icons.photo),
                          title: const Text('Choose from gallery'),
                          onTap: () async {
                            await Future.delayed(const Duration(seconds: 1));
                            final picked = await picker.pickImage(
                                source: ImageSource.gallery);

                            if (context.mounted) {
                              Navigator.of(context).pop(picked);
                            }
                          },
                        ),
                        const SizedBox(height: 10),
                      ],
                    ),
                  );
                },
              );

              if (!context.mounted) return;

              if (pickedFile != null) {}
            },
            child: Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Colors.white,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 20,
                color: AppColors.primary,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
