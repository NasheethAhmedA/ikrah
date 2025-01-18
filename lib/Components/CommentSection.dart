import 'package:flutter/material.dart';

class CommentSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [
        const Center(
          child: Text("Comment Section is not implemented yet!",
              style: TextStyle(
                fontSize: 24.0,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center),
        ),
        PositionedDirectional(
          end: 10,
          top: 10,
          child: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => Navigator.pop(context)),
        ),
      ],
    );
  }
}
