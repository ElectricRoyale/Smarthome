import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import '../generated/l10n.dart';

class UnavailableDialog extends StatelessWidget {
  final Function onPop;
  const UnavailableDialog(this.onPop, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final delegate = S.of(context);
    return WillPopScope(
      onWillPop: () async {
        onPop.call();
        return false;
      },
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 2.0, sigmaY: 2.0),
        child: Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          elevation: 0,
          backgroundColor: Colors.transparent,
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Padding(
                padding: const EdgeInsets.only(bottom: 240),
                child: SvgPicture.asset(
                  'assets/error.svg',
                  width: 120,
                  height: 120,
                  fit: BoxFit.cover,
                )),
            Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  delegate.unavailableTitle,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 26),
                ),
                Text(
                  delegate.unavailableMessage,
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ]),
        ),
      ),
    );
  }
}
