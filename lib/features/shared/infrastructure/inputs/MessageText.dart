import 'package:formz/formz.dart';

enum MessageTextError { empty }

class MessageText extends FormzInput<String, MessageTextError> {
  const MessageText.pure() : super.pure('');

  const MessageText.dirty(super.value) : super.dirty();

  String? get errorMessage {
    if (isValid || isPure) return null;

    if (displayError == MessageTextError.empty) return 'El campo es requerido';

    return null;
  }

  @override
  MessageTextError? validator(String value) {
    if (value.isEmpty || value.trim().isEmpty) return MessageTextError.empty;
    return null;
  }
}
