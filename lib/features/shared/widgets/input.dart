import 'package:flutter/material.dart';

class Input extends StatefulWidget {
  final String hintText;
  final String? errorMessage;
  final bool obscureText;
  final TextInputType keyboardType;
  final void Function(String)? onChanged;

  const Input({
    super.key,
    required this.hintText,
    this.errorMessage,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.onChanged,
  });
  @override
  State<Input> createState() => _InputState();
}

class _InputState extends State<Input> {
  late FocusNode _focusNode;
  late final TextEditingController _controller;

  _onFocusChange() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
    _focusNode = FocusNode();
    _focusNode.addListener(_onFocusChange);
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
    bool obscureText = widget.obscureText;
    final inputDecoration = InputDecoration(
      hintText: widget.hintText,
      errorText: widget.errorMessage,

      suffixIcon:
          obscureText
              ? IconButton(
                onPressed: () {
                  setState(() {
                    obscureText = !obscureText;
                  });
                },
                icon: Icon(
                  obscureText ? Icons.visibility_off : Icons.visibility,
                ),
              )
              : null,
    );

    return TextFormField(
      keyboardType: widget.keyboardType,
      controller: _controller,
      focusNode: _focusNode,
      obscureText: obscureText,
      decoration: inputDecoration,
      onChanged: widget.onChanged,
    );
  }
}
