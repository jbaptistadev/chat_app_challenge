import 'package:epale_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:epale_app/features/shared/infrastructure/inputs/email.dart';
import 'package:epale_app/features/shared/infrastructure/inputs/password.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final signInFormProvider =
    StateNotifierProvider.autoDispose<SignInFormNotifier, SignInFormState>((
      ref,
    ) {
      final signInUserCallback = ref.watch(authProvider.notifier).signIn;
      return SignInFormNotifier(signInUserCallback: signInUserCallback);
    });

class SignInFormNotifier extends StateNotifier<SignInFormState> {
  final Function(String, String) signInUserCallback;

  SignInFormNotifier({required this.signInUserCallback})
    : super(SignInFormState());

  void onEmailChange(String email) {
    state = state.copyWith(email: Email.dirty(email));
  }

  void onPasswordChange(String password) {
    state = state.copyWith(password: Password.dirty(password));
  }

  void onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    await signInUserCallback(state.email.value, state.password.value);
    state = state.copyWith(isPosting: false);
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      isValid: Formz.validate([email, password]),
    );
  }
}

class SignInFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;

  SignInFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
  });

  SignInFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
  }) => SignInFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,
  );
}
