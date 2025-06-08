import 'package:epale_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:epale_app/features/auth/presentation/providers/signin_form_provider.dart';
import 'package:epale_app/features/shared/widgets/button.dart';
import 'package:epale_app/features/shared/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatelessWidget {
  const SignInScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(body: SafeArea(child: _SignInForm())),
    );
  }
}

class _SignInForm extends ConsumerWidget {
  const _SignInForm();

  void showSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signInForm = ref.watch(signInFormProvider);

    ref.listen(authProvider, (previous, next) {
      if (next.errorMessage.isEmpty) return;
      showSnackbar(context, next.errorMessage);
    });

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 30),
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: 100),
                  Center(
                    child: Text('Sign In', style: TextStyle(fontSize: 25)),
                  ),
                  SizedBox(height: 20),
                  SizedBox(height: 60),
                  Input(
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email',
                    errorMessage:
                        signInForm.isFormPosted
                            ? signInForm.email.errorMessage
                            : null,
                    onChanged:
                        ref.read(signInFormProvider.notifier).onEmailChange,
                  ),
                  const SizedBox(height: 20),
                  Input(
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Password',
                    isObscureText: true,
                    errorMessage:
                        signInForm.isFormPosted
                            ? signInForm.password.errorMessage
                            : null,
                    onChanged:
                        ref.read(signInFormProvider.notifier).onPasswordChange,
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => context.push('/signup'),
                    child: Text('Don\'t have an account? Sign Up'),
                  ),
                ],
              ),
            ),
          ),
          Button(
            text: 'Sign In',
            onTap: () => ref.read(signInFormProvider.notifier).onFormSubmit(),
            isDisabled: signInForm.isPosting,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
