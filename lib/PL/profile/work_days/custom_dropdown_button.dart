import 'package:clinic_admin/PL/profile/work_days/work_days_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class CustomDropdownButton extends StatefulWidget {

  _CustomDropdownButtonState createState() => _CustomDropdownButtonState();
}

class _CustomDropdownButtonState extends State<CustomDropdownButton> {

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("اليوم",style: TextStyle(color: Colors.black54,),),
        DropdownButton<String>(
          items: <String>["السبت","الأحد","الاثنين","الثلاثاء","الاربعاء","الخميس","الجمعة"]
              .map<DropdownMenuItem<String>>((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          value: WorkDays.selectedDay,
          isExpanded: true,

          underline: Container(
            height: 1.2,
            color: Colors.black38,
          ),
          onChanged: (String? newValue) {

            setState(()=>WorkDays.selectedDay=newValue!);
        },


        ),
      ],
    );
  }
}
