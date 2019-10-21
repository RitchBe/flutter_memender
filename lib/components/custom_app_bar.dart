import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:memender/constants.dart';

import '../constants.dart';

class CustomAppBar extends StatelessWidget with PreferredSizeWidget {

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0.0,
      backgroundColor: kWhite,
      title:
      Padding(
        padding: const EdgeInsets.all(14.0),
        child: SvgPicture.asset('assets/logoSvg.svg'),
      ),

      leading: Builder(builder: (BuildContext context) {
        return IconButton(
          icon:  Icon(Icons.menu, color: kHighlightColor, size: 24.0,),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
          splashColor: kOpacityColor,
          highlightColor: kOpacityColor,
          tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
        );
      }),

      actions: <Widget>[
        Builder(builder: (BuildContext context) {
          return IconButton(
            icon:  Icon(Icons.info_outline, color: kHighlightColor, size: 24.0),
            splashColor: kOpacityColor,
            highlightColor: kOpacityColor,
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
          );
        }),
      ],
    );
  }
}
