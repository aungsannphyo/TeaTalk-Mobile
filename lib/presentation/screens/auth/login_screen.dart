import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:go_router/go_router.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';

import '../../widgets/common_button_widget.dart';
import '../../widgets/custom_snack_bar_widget.dart';
import '../../../routes/routes_name.dart';
import '../../providers/auth/login_provider.dart';
import '../../../style/text_style.dart';
import '../../../style/theme/app_color.dart';
import '../../widgets/custom_text_form_field_widget.dart';

class LoginScreen extends HookConsumerWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final formKey = GlobalKey<FormState>();
    final emailController = useTextEditingController();
    final passwordController = useTextEditingController();
    final obscurePassword = useState(true);
    final authState = ref.watch(loginProvider);

    void onLogin() {
      if (formKey.currentState!.validate()) {
        ref
            .read(loginProvider.notifier)
            .login(emailController.text, passwordController.text);
      }
    }

    ref.listen<AuthState>(
      loginProvider,
      (previous, next) {
        if (next.error != null && next.error!.isNotEmpty) {
          SnackbarUtil.showError(context, next.error!);
        }
      },
    );

    void navigateToRegister() {
      GoRouter.of(context).pushNamed(RouteName.register);
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
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/login.png',
                    width: 170,
                    height: 170,
                    fit: BoxFit.contain,
                  ),
                  const SizedBox(height: 24),
                  Text('Tea Talk',
                      style: AppTextStyles.bold.copyWith(fontSize: 24)),
                  const SizedBox(height: 32),
                  CustomTextFormField(
                    controller: emailController,
                    labelText: 'Email',
                    keyboardType: TextInputType.emailAddress,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Email must not be empty!'
                        : null,
                    prefixIcon: Icons.email_outlined,
                  ),
                  const SizedBox(height: 16),
                  CustomTextFormField(
                    controller: passwordController,
                    labelText: 'Password',
                    obscureText: obscurePassword.value,
                    isPassword: true,
                    onToggleObscure: () =>
                        obscurePassword.value = !obscurePassword.value,
                    validator: (val) => val == null || val.isEmpty
                        ? 'Password must not be empty!'
                        : null,
                    prefixIcon: Icons.lock_outline,
                  ),
                  const SizedBox(height: 16),
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                      onPressed: () {},
                      child: Text('Forgot Password?',
                          style: AppTextStyles.regular
                              .copyWith(color: AppColors.primary)),
                    ),
                  ),
                  const SizedBox(height: 16),
                  CommonButtonWidget(
                    isLoading: authState.isLoading,
                    label: 'Login',
                    onPressed: onLogin,
                  ),
                  const SizedBox(height: 24),
                  Row(
                    children: [
                      const Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        child: Text('or', style: AppTextStyles.regular),
                      ),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 24),
                  TextButton(
                    onPressed: navigateToRegister,
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: AppTextStyles.regular,
                        children: [
                          TextSpan(
                            text: "Sign up",
                            style: AppTextStyles.semiBold
                                .copyWith(color: AppColors.accent),
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
