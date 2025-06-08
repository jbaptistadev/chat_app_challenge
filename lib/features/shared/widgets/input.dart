import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final String hintText;
  final String? errorMessage;
  final bool isObscureText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  const Input({
    super.key,
    required this.hintText,
    this.errorMessage,
    this.isObscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });
  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late FocusNode _focusNode;
  late final TextEditingController _controller;
  bool _obscureText = false;

  _onFocusChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
    _obscureText = widget.isObscureText;
  }

  @override
  void dispose() {
    _controller.dispose();
    _focusNode.removeListener(_onFocusChange);
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final inputDecoration = InputDecoration(
      hintText: widget.hintText,
      errorText: widget.errorMessage,

      suffixIcon:
          widget.isObscureText
              ? IconButton(
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              )
              : null,
    );

    return TextFormField(
      keyboardType: widget.keyboardType,
      controller: _controller,
      focusNode: _focusNode,
      obscureText: _obscureText,
      decoration: inputDecoration,
      onChanged: widget.onChanged,
    );
  }
}
