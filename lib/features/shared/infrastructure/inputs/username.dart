import 'package:formz/formz.dart';

enum UsernameError { empty, format }

class Username extends FormzInput<String, UsernameError> {
  static final RegExp usernameRegExp = RegExp(r'^[A-Za-z0-9_]{3,24}$');

  const Username.pure() : super.pure('');

  const Username.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == UsernameError.empty) return 'El campo es requerido';
    if (displayError == UsernameError.format) {
      return 'No tiene formato de nombre de usuario';
    }

    return null;
  }

  @override
  UsernameError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return UsernameError.empty;
    if (!usernameRegExp.hasMatch(value)) return UsernameError.format;

    return null;
  }
}
