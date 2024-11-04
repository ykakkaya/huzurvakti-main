import 'package:flutter/material.dart';

class LoadingIndicator extends StatelessWidget {
  const LoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) => const Center(
        child: CircularProgressIndicator.adaptive(
          backgroundColor: Colors.purple,
          valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
        ),
      );
}
