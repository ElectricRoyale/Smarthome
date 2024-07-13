import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/l10n.dart';

class ErrorDialog extends StatelessWidget {
  final bool _retry;
  final Function onRetry;

  const ErrorDialog(this._retry, this.onRetry, {super.key});

  @override
  Widget build(BuildContext context) {
    Size screenSize = MediaQuery.sizeOf(context);
    final delegate = S.of(context);
    return WillPopScope(
      onWillPop: () async => false,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Align(
                child: SvgPicture.asset(
              'assets/error.svg',
              width: screenSize.width * 0.2916666,
              height: screenSize.width * 0.2916666,
              fit: BoxFit.cover,
            )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  delegate.connectionerrorTitle,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
                Text(
                  delegate.connectionerrorMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
                if (_retry)
                  TextButton(
                      onPressed: () => onRetry.call(),
                      child: Text(delegate.retry)),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
