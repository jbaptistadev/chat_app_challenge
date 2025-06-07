import 'package:epale_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:epale_app/features/shared/infrastructure/inputs/email.dart';
import 'package:epale_app/features/shared/infrastructure/inputs/password.dart';
import 'package:epale_app/features/shared/infrastructure/inputs/username.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:formz/formz.dart';

final signUpFormProvider =
    StateNotifierProvider.autoDispose<SignUpFormNotifier, SignUpFormState>((
      ref,
    ) {
      final signUpUserCallback = ref.watch(authProvider.notifier).signUp;
      return SignUpFormNotifier(signUpUserCallback: signUpUserCallback);
    });

class SignUpFormNotifier extends StateNotifier<SignUpFormState> {
  final Function(String, String, String) signUpUserCallback;

  SignUpFormNotifier({required this.signUpUserCallback})
    : super(SignUpFormState());

  void onEmailChange(String email) {
    state = state.copyWith(email: Email.dirty(email));
  }

  void onPasswordChange(String password) {
    state = state.copyWith(password: Password.dirty(password));
  }

  void onUsernameChange(String username) {
    state = state.copyWith(username: Username.dirty(username));
  }

  void onFormSubmit() async {
    _touchEveryField();
    if (!state.isValid) return;
    state = state.copyWith(isPosting: true);
    await signUpUserCallback(
      state.email.value,
      state.password.value,
      state.username.value,
    );
    state = state.copyWith(isPosting: false);
  }

  void _touchEveryField() {
    final email = Email.dirty(state.email.value);
    final password = Password.dirty(state.password.value);
    final username = Username.dirty(state.username.value);

    state = state.copyWith(
      isFormPosted: true,
      email: email,
      password: password,
      username: username,
      isValid: Formz.validate([email, password, username]),
    );
  }
}

class SignUpFormState {
  final bool isPosting;
  final bool isFormPosted;
  final bool isValid;
  final Email email;
  final Password password;
  final Username username;

  SignUpFormState({
    this.isPosting = false,
    this.isFormPosted = false,
    this.isValid = false,
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.username = const Username.pure(),
  });

  SignUpFormState copyWith({
    bool? isPosting,
    bool? isFormPosted,
    bool? isValid,
    Email? email,
    Password? password,
    Username? username,
  }) => SignUpFormState(
    isPosting: isPosting ?? this.isPosting,
    isFormPosted: isFormPosted ?? this.isFormPosted,
    isValid: isValid ?? this.isValid,
    email: email ?? this.email,
    password: password ?? this.password,
    username: username ?? this.username,
  );
}
