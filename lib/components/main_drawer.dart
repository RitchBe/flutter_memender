import 'package:flutter/material.dart';

import 'package:memender/constants.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment(-1.0, -0.73),
      child: AnimatedContainer(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(bottomRight: Radius.circular(10.0)),
          color: kWhite,
          boxShadow: [
            BoxShadow(
              color: kOpacityColor,
              blurRadius: 5.0, // has the effect of softening the shadow
              spreadRadius: 1.0, // has the effect of extending the shadow
              offset: Offset(
                2.0, // horizontal, move right 10
                7.0, // vertical, move down 10
              ),
            )
          ],
        ),
        width: 170.0,
        height: 200.0,
        duration: Duration(seconds: 1),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {
                      print('no');
                      Navigator.popAndPushNamed(context, '/');
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Random',
                        style: kDrawerText,
                      ),
                    ),
                  ),
                  Divider(
                    color: kHighlightColor,
                    indent: 15.0,
                    endIndent: 15.0,
                    height: 0.0,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {
                      print('mofo');
                      Navigator.popAndPushNamed(context, '/top', arguments: 'all-time');
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        'All Time Top',
                        style: kDrawerText,
                      ),
                    ),
                  ),
                  Divider(
                    color: kHighlightColor,
                    indent: 15.0,
                    endIndent: 15.0,
                    height: 0.0,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/top', arguments: 'monthly');
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Monthly Top',
                        style: kDrawerText,
                      ),
                    ),
                  ),
                  Divider(
                    color: kHighlightColor,
                    indent: 15.0,
                    endIndent: 15.0,
                    height: 0.0,
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  RawMaterialButton(
                    onPressed: () {
                      Navigator.pushNamed(context, '/top', arguments: 'weelky');
                    },
                    child: Padding(
                      padding: EdgeInsets.only(left: 15.0),
                      child: Text(
                        'Weekly Top',
                        style: kDrawerText,
                      ),
                    ),
                  ),
                  Divider(
                    color: kHighlightColor,
                    indent: 15.0,
                    endIndent: 15.0,
                    height: 0.0,
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
