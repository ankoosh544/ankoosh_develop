import 'package:flutter/material.dart';

class OutOfServiceMessage extends StatelessWidget {
  final String message;

  OutOfServiceMessage({required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16.0),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(8.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.warning,
            color: Colors.white,
            size: 24.0,
          ),
          SizedBox(width: 8.0),
          Flexible(
            child: Text(
              message,
              textAlign: TextAlign.center,
              style: Theme.of(context)
                  .textTheme
                  .bodyLarge
                  ?.copyWith(color: Colors.white),
            ),
          ),
        ],
      ),
    );
  }
}
