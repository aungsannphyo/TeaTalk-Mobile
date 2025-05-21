import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import '../../domain/events/register_event.dart';
import '../../routes/routes_name.dart';
import '../../style/text_style.dart';
import '../../style/theme/color.dart';
import '../providers/user/register_provider.dart';
import '../widgets/auth/auth_button_widget.dart';
import '../widgets/common/custom_text_form_field_widget.dart';
import '../widgets/common/custom_snack_bar_widget.dart';

class RegisterScreen extends HookConsumerWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final usernameController = useTextEditingController();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final confirmPasswordController = useTextEditingController();
    final obscurePassword = useState(true);
    final obscureConfirmPassword = useState(true);

    final registerState = ref.watch(registerProvider);

    // print("ERROR ${authState.error}");

    void onRegister() {
      if (formKey.currentState!.validate()) {
        final RegisterEvent event = RegisterEvent(
          username: usernameController.text,
          email: emailController.text,
          password: passwordController.text,
        );
        ref.read(registerProvider.notifier).register(event);
      }
    }

    ref.listen<RegisterState>(
      registerProvider,
      (previous, next) {
        if (next.error != null && next.error!.isNotEmpty) {
          SnackbarUtil.showError(context, next.error!);
        }
      },
    );

    ref.listen<RegisterState>(
      registerProvider,
      (previous, next) {
        if (next.isSuccess) {
          SnackbarUtil.showSuccess(
            context,
            "Registration successful! Welcome aboard — let's get started.",
          );

          usernameController.clear();
          emailController.clear();
          passwordController.clear();
          confirmPasswordController.clear();

          Future.delayed(const Duration(seconds: 2), () {
            if (context.mounted) {
              GoRouter.of(context).pushReplacementNamed(RouteName.login);
            }
          });
        }
      },
    );

    void navigateToLogin() {
      GoRouter.of(context).pushNamed(RouteName.login);
    }

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
            child: Form(
              key: formKey,
              child: Column(
                children: [
                  SvgPicture.asset('assets/images/register.svg', height: 180),
                  const SizedBox(height: 24),
                  Text(
                    "Let’s Talk on YwarTalk",
                    style: AppTextStyles.bold
                        .copyWith(fontSize: 24, color: AppColors.primary),
                  ),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    controller: usernameController,
                    labelText: "Your Name",
                    validator: (val) => val == null || val.isEmpty
                        ? "Please enter your name."
                        : null,
                    prefixIcon: Icons.person_outline,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: emailController,
                    labelText: "Email",
                    validator: (val) => val == null || val.isEmpty
                        ? "Please enter your email."
                        : null,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: passwordController,
                    labelText: "Password",
                    obscureText: obscurePassword.value,
                    isPassword: true,
                    onToggleObscure: () =>
                        obscurePassword.value = !obscurePassword.value,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please enter your password.";
                      } else if (val.length < 6) {
                        return "Password must be at least 7 characters long.";
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: confirmPasswordController,
                    labelText: "Confirm Password",
                    obscureText: obscureConfirmPassword.value,
                    isPassword: true,
                    onToggleObscure: () => obscureConfirmPassword.value =
                        !obscureConfirmPassword.value,
                    validator: (val) {
                      if (val == null || val.isEmpty) {
                        return "Please confirm your password";
                      }
                      if (val != passwordController.text) {
                        return "Passwords do not match";
                      }
                      return null;
                    },
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 24),
                  AuthButtonWidget(
                    isLoading: registerState.isLoading,
                    label: 'Register',
                    onPressed: onRegister,
                  ),
                  const SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      navigateToLogin();
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Already have an account? ",
                        style: AppTextStyles.regular
                            .copyWith(color: AppColors.textDark),
                        children: [
                          TextSpan(
                              text: "Login",
                              style: AppTextStyles.semiBold
                                  .copyWith(color: AppColors.accent)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
