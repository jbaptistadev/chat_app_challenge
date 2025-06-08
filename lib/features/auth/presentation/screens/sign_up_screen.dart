import 'package:epale_app/features/auth/presentation/providers/signup_form_provider.dart';
import 'package:epale_app/features/shared/widgets/button.dart';
import 'package:epale_app/features/shared/widgets/input.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(body: SafeArea(child: _SignUpForm())),
    );
  }
}

class _SignUpForm extends ConsumerWidget {
  const _SignUpForm();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final signUpForm = ref.watch(signUpFormProvider);

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
                    child: Text('Sign Up', style: TextStyle(fontSize: 25)),
                  ),

                  SizedBox(height: 80),
                  Input(
                    keyboardType: TextInputType.emailAddress,
                    hintText: 'Email',
                    errorMessage:
                        signUpForm.isFormPosted
                            ? signUpForm.email.errorMessage
                            : null,
                    onChanged:
                        ref.read(signUpFormProvider.notifier).onEmailChange,
                  ),
                  const SizedBox(height: 20),
                  Input(
                    keyboardType: TextInputType.text,
                    hintText: 'Username',
                    errorMessage:
                        signUpForm.isFormPosted
                            ? signUpForm.username.errorMessage
                            : null,
                    onChanged:
                        ref.read(signUpFormProvider.notifier).onUsernameChange,
                  ),
                  const SizedBox(height: 20),
                  Input(
                    keyboardType: TextInputType.visiblePassword,
                    hintText: 'Password',
                    isObscureText: true,
                    errorMessage:
                        signUpForm.isFormPosted
                            ? signUpForm.password.errorMessage
                            : null,
                    onChanged:
                        ref.read(signUpFormProvider.notifier).onPasswordChange,
                  ),
                  const SizedBox(height: 20),

                  TextButton(
                    onPressed: () => context.push('/signin'),
                    child: Text('Already have an account? Sign In'),
                  ),
                ],
              ),
            ),
          ),
          Button(
            text: 'Sign Up',
            onTap: () => ref.read(signUpFormProvider.notifier).onFormSubmit(),
            isDisabled: signUpForm.isPosting,
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
