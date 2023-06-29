// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

class CommentField extends StatefulWidget {
  const CommentField({
    Key? key,
    required this.onSubmit,
  }) : super(key: key);
  final void Function(String comment) onSubmit;

  @override
  State<CommentField> createState() => _CommentFieldState();
}

class _CommentFieldState extends State<CommentField> {
  final _ctrl = TextEditingController();

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: _ctrl,
      onFieldSubmitted: (value) {
        widget.onSubmit(_ctrl.text);
        _ctrl.clear();
      },
      decoration: InputDecoration(
        hintText: 'Say something...',
        suffix: IconButton(
          onPressed: () {
            widget.onSubmit(_ctrl.text);
            _ctrl.clear();
          },
          icon: const Icon(Icons.send),
        ),
      ),
    );
  }
}
