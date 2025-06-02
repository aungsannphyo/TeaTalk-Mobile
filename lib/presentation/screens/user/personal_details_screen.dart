import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/events/user/update_personal_details_event.dart';
import '../../../domain/events/user/update_user_name_event.dart';
import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';
import '../../../utils/gender.dart';
import '../../providers/user/get_user_provider.dart';
import '../../providers/user/update_personal_details_provider.dart';
import '../../providers/user/update_username_provider.dart';
import '../../providers/user/user_profile_upload_provider.dart';
import '../../widgets/common_avatar_widget.dart';
import '../../widgets/common_button_widget.dart';
import '../../widgets/custom_snack_bar_widget.dart';
import '../../widgets/date_picker/common_date_picker_wheel_widget.dart';
import '../../widgets/date_picker/common_date_picker_widget.dart';
import '../../widgets/common_image_upload_widget.dart';
import '../../widgets/common_select_box_widget.dart';
import '../../widgets/custom_text_form_field_widget.dart';
import '../../widgets/loading/common_loading_widget.dart';

class PersonalDetailsScreen extends HookConsumerWidget {
  const PersonalDetailsScreen({super.key});

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: AppColors.primary,
      centerTitle: true,
      title: const Text(
        'Personal Details',
        style: AppTextStyles.appBarTitle,
      ),
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatePersonalDetails = ref.watch(updatePersonalDetailsProvider);
    final UserState userState = ref.watch(getUserProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final imageFile = useState<File?>(null);
    final selectedGender = useState<Gender?>(null);
    final dateOfBirth = useState<DateTime?>(null);
    final dobController = useTextEditingController();
    final bioController = useTextEditingController();
    final usernameController = useTextEditingController();
    final remainingChars = useState(70);

    // Trigger fetch user once on mount
    useEffect(() {
      Future.microtask(() {
        ref.read(getUserProvider.notifier).getUser();
      });
      return null;
    }, []);

    // Only run this effect when user and details are available
    useEffect(() {
      final user = userState.user;
      final details = userState.details;
      if (user != null && details != null) {
        bioController.text = details.bio ?? '';
        remainingChars.value = 70 - bioController.text.length;

        if (details.dateOfBirth != null && details.dateOfBirth!.isNotEmpty) {
          dobController.text = details.dateOfBirth!;
        }
        if (details.gender != null) {
          selectedGender.value = details.gender;
        }
        usernameController.text = user.username;
      }
      return null;
    }, [userState.user, userState.details]);

    useEffect(() {
      if (dateOfBirth.value != null) {
        final d = dateOfBirth.value!;
        dobController.text = "${d.day}/${d.month}/${d.year}";
      }
      void listener() {
        remainingChars.value = 70 - bioController.text.length;
      }

      bioController.addListener(listener);
      return () => bioController.removeListener(listener);
    }, [dateOfBirth.value]);

    Future<void> pickDate() async {
      final now = DateTime.now();
      final initialDate = dateOfBirth.value ?? DateTime(now.year - 18);

      await showModalBottomSheet(
        context: context,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        backgroundColor: Colors.white,
        isScrollControlled: true,
        builder: (context) {
          return CommonDatePickerWheelWidget(
            initialDate: initialDate,
            onDateSelected: (selectedDate) {
              dateOfBirth.value = selectedDate;
              dobController.text =
                  "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";
            },
          );
        },
      );
    }

    void savePersonalDetails() {
      if (selectedGender.value == null) {
        // You might want to show an error or prevent saving if gender is null
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select a gender')),
        );
        return;
      }

      final detailsEvent = UpdatePersonalDetailsEvent(
        bio: bioController.text,
        dateOfBirth: dobController.text,
        gender: selectedGender.value!,
      );
      final userEvent = UpdateUserNameEvent(username: usernameController.text);

      ref.read(updateUserNameProvider.notifier).updateUsername(userEvent);
      ref
          .read(updatePersonalDetailsProvider.notifier)
          .updateUserPersonalDetails(detailsEvent);

      // Re-fetch user after update to refresh UI safely
      ref.read(getUserProvider.notifier).getUser();
    }

    void onUploadImage(File file) {
      imageFile.value = file;
      ref.read(userProfileUploadProvider.notifier).uploadProfileImage(file);
    }

    ref.listen<UpdatePersonalDetailsState>(
      updatePersonalDetailsProvider,
      (previous, next) {
        if (next.isSuccess) {
          SnackbarUtil.showSuccess(
            context,
            "Update complete. You're all set!",
          );
        }
        if (next.error != null && next.error!.isNotEmpty) {
          SnackbarUtil.showError(context, next.error!);
        }
      },
    );

    if (userState.user == null || userState.details == null) {
      return Stack(
        children: [
          Scaffold(
            appBar: _buildAppBar(),
          ),
          const CommonLoadingWidget(),
        ],
      );
    }

    final user = userState.user!;
    final details = userState.details!;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: _buildAppBar(),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CommonAvatarWidget(
                      username: user.username,
                      profileImage: details.profileImage,
                      imageFile: imageFile.value,
                      radius: 50,
                    ),
                    CommonImageUploadWidget(
                      onImagePicked: (file) {
                        onUploadImage(file);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Gender',
                    style: AppTextStyles.semiBold.copyWith(fontSize: 16),
                  ),
                ),
                CommonSelectBoxWidget<Gender>(
                  values: Gender.values,
                  selectedValue: selectedGender.value,
                  onSelect: (g) => selectedGender.value = g,
                  labelBuilder: getGenderLabel,
                  errorText: selectedGender.value == null
                      ? 'Please select a gender'
                      : null,
                ),
                const SizedBox(height: 24),
                CustomTextFormField(
                  controller: usernameController,
                  prefixIcon: Icons.person_outline,
                  labelText: "Your Name",
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Bio',
                    style: AppTextStyles.semiBold.copyWith(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                CustomTextFormField(
                  controller: bioController,
                  labelText: 'Tell us about yourself...',
                  maxLength: 70,
                  maxLines: 5,
                  minLines: 1,
                  counterText: "${remainingChars.value} characters left",
                ),
                const SizedBox(height: 24),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Your Birthday',
                    style: AppTextStyles.semiBold.copyWith(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 10),
                CommonDatePickerWidget(
                  datePickerController: dobController,
                  label: "Date of Birth",
                  pickDate: pickDate,
                ),
                const SizedBox(height: 32),
                CommonButtonWidget(
                  isLoading: updatePersonalDetails.isLoading,
                  label: "Save",
                  onPressed: savePersonalDetails,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
