import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

const pageParams = [
  {'name':'Rooms', 'icon':'assets/house_app_icon.svg', 'layout': CustomAppBar.APP_BAR_WITH_ICONS},
  {'name':'Network', 'icon':'assets/refresh.svg', 'layout': CustomAppBar.APP_BAR_WITH_ICONS},
  {'name':'Settings', 'con':'', 'layout': CustomAppBar.APP_BAR_WITHOUT_ICONS},
];

class CustomAppBar extends StatefulWidget with PreferredSizeWidget {
  @override
  final Size preferredSize;

  static const APP_BAR_WITH_ICONS = 0;
  static const APP_BAR_WITHOUT_ICONS = 1;

  CustomAppBarLayout customAppBarLayout = CustomAppBarLayout();

  CustomAppBar ({Key? key})
      : preferredSize = Size.fromHeight(70.0),
        super(key: key);

  @override
  State<StatefulWidget> createState() => customAppBarLayout;

  void update(int index){
    customAppBarLayout.changeIndex(index);
  }

}
class CustomAppBarLayout extends State<CustomAppBar>{

  int index = 0;

  void changeIndex(int index){
    setState(() {
      this.index = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    switch (pageParams.elementAt(index)['layout']) {
      case 0:
        return AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          leading: Transform.translate(
              offset: Offset(15, 8),
              child: IconButton(
                  icon: SvgPicture.asset('${pageParams.elementAt(index)['icon']}',
                      height: 30, width: 30, fit: BoxFit.scaleDown),
                  onPressed: () {})),
          titleSpacing: 0,
          title: Padding(
            padding: EdgeInsets.only(top: 20),
            child: Text('${pageParams.elementAt(index)['name']}',
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
            child: Text('${pageParams.elementAt(index)['name']}',
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
