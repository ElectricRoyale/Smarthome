import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  final String title, svgIcon;
  final int appBar;
  static int APP_BAR_WITH_ICONS = 0;
  static int APP_BAR_WITHOUT_ICONS = 1;

  CustomAppBar(this.title, this.svgIcon, this.appBar, {Key? key})
      : preferredSize = Size.fromHeight(70.0),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    switch (appBar) {
      case 0:
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Transform.translate(
              offset: Offset(15, 8),
              child: IconButton(
                  icon: SvgPicture.asset(svgIcon,
                      height: 30, width: 30, fit: BoxFit.scaleDown),
                  onPressed: () {})),
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(title,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                textScaleFactor: 1.3),
          ),
          actions: [
            Transform.translate(
                offset: Offset(-15, 13),
                child: IconButton(
                    icon: SvgPicture.asset('assets/full_signal.svg'),
                    onPressed: () {})),
          ],
        );
      case 1:
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text(title,
                style:
                    TextStyle(color: Colors.white, fontWeight: FontWeight.w900),
                textScaleFactor: 1.3),
          ),
        );
      default:
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
        );
    }
  }
}
