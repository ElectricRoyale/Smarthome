import 'package:flutter/material.dart';

import '../utils/constants.dart';

class Statistics extends StatelessWidget {
  const Statistics({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            BACKGROUND_START,
            BACKGROUND_END,
          ],
        ),
      ),
      child: const Scaffold(

      ),
    );
  }
}
