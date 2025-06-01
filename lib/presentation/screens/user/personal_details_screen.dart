import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../../domain/events/update_personal_details_event.dart';
import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';
import '../../../utils/gender.dart';
import '../../providers/user/update_personal_details_provider.dart';
import '../../providers/user/user_profile_upload_provider.dart';
import '../../widgets/common_button_widget.dart';
import '../../widgets/custom_snack_bar_widget.dart';
import '../../widgets/date_picker/common_date_picker_wheel_widget.dart';
import '../../widgets/date_picker/common_date_picker_widget.dart';
import '../../widgets/common_image_upload_widget.dart';
import '../../widgets/common_select_box_widget.dart';
import '../../widgets/custom_text_form_field_widget.dart';

class PersonalDetailsScreen extends HookConsumerWidget {
  const PersonalDetailsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final updatePersonalDetails = ref.watch(updatePersonalDetailsProvider);
    final formKey = useMemoized(() => GlobalKey<FormState>());
    final imageFile = useState<File?>(null);
    final selectedGender = useState<Gender?>(null);
    final dateOfBirth = useState<DateTime?>(null);
    final dobController = useTextEditingController();
    final bioController = useTextEditingController();
    final remainingChars = useState(70);

    // Bind DOB text when date changes
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
      final event = UpdatePersonalDetailsEvent(
        bio: bioController.text,
        dateOfBirth: dobController.text,
        gender: selectedGender.value!,
      );

      ref
          .read(updatePersonalDetailsProvider.notifier)
          .updateUserPersonalDetails(event);
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

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        centerTitle: true,
        title: const Text(
          'Personal Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
            letterSpacing: 0.8,
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
          child: Form(
            key: formKey,
            child: Column(
              children: [
                //  Profile Image Picker with edit icon
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    CircleAvatar(
                      radius: 50,
                      backgroundColor:
                          AppColors.primary.withAlpha((0.1 * 255).round()),
                      backgroundImage: imageFile.value != null
                          ? FileImage(imageFile.value!)
                          : null,
                      child: imageFile.value == null
                          ? Icon(Icons.person,
                              size: 50, color: Colors.grey[400])
                          : null,
                    ),
                    CommonImageUploadWidget(
                      onImagePicked: (file) {
                        onUploadImage(file);
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 28),
                //  Gender
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Gender',
                      style: AppTextStyles.semiBold.copyWith(fontSize: 16)),
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

                //  Date of Birth Field (styled)
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
                //  Save Button
                CommonButtonWidget(
                  isLoading: updatePersonalDetails.isLoading,
                  label: "Save",
                  onPressed: () {
                    savePersonalDetails();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
