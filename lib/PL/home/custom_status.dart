import 'package:clinic_admin/PL/profile/work_days/work_days_widget.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';
class CustomPlaceStatus extends StatelessWidget {
   UserProvider userProvider;

   CustomPlaceStatus(this.userProvider);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
              child: Row(children: [
                Radio<String>(
                  value: "1",
                  groupValue: HomePage.placeStatus,
                  onChanged: (String? value) {
                HomePage.placeStatus = value!;
                userProvider.refresh();

                },
                ),
                Text('فتح')
              ])),
          SizedBox(width: 10,),
          Container(
              child: Row(children: [
                Radio<String>(
                  value: "0",
                  groupValue: HomePage.placeStatus,
                  onChanged: (String? value) {
                    HomePage.placeStatus = value!;
                userProvider.refresh();

                },
                ),
                Text('إغلاق')
              ]))
        ]
    );
  }
}
