import 'package:clinic_admin/constants.dart';
import 'package:flutter/material.dart';

class CustomNotifyWidget extends StatelessWidget {
  final int? count;
  final Function()? onPress;
  final IconData? icon;
  final String? page;
  CustomNotifyWidget(
      {@required this.count, @required this.onPress, @required this.icon,@required this.page});

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      IconButton(
          icon: Icon(
            icon,
            color: page=='home'?primaryColor:Colors.white,
          ),
          onPressed: onPress),
      count == 0 || count == null
          ? Container()
          : Positioned(
              right: 2,
              top: 0,
              child: Stack(
                children: [
                  Icon(
                    Icons.brightness_1,
                    size: 25,
                    color: Colors.red,
                  ),
                  Positioned(
                      top: 5.0,
                      bottom: 4.0,
                      right: count! > 99
                          ? 3.0
                          : count! > 9
                              ? 6.5
                              : 9.0,
                      child: Text(
                        count! > 99 ? "+99" : "$count",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 10.0,
                            fontWeight: FontWeight.w500),
                      ))
                ],
              ),
            )
    ]);
  }
}
