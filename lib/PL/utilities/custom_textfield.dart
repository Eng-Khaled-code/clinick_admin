import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String? lable;
  final Color? color;
  final IconData? icon;

  final Function(String value)? onSave;

  CustomTextField({
    @required this.lable,
    @required this.icon,
    @required this.onSave,
    this.color=Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: color,
      elevation: 1,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: TextFormField( onSaved: (value) {
          onSave!(value!);
        },
          validator:(value){
          if(value!.isEmpty)
            return "من فضلك إدخل "+lable!;

          },
          style: TextStyle(fontSize: MediaQuery.of(context).size.width * .04),
          decoration: InputDecoration(
border:InputBorder.none,
            labelText: lable,
            labelStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * .035,
            ),

            icon: Icon(
              icon,
            )

        ),
      ),
    ));
  }
}
