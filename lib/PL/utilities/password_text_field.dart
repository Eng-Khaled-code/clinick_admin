import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  final String? lable;
  final Color? color;
  final Function(String value)? onSave;

  PasswordTextField(
      {@required this.lable,
       this.color=Colors.white,
      @required this.onSave,
      });

  @override
  _PasswordTextFieldState createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool hidePass = true;
  IconData hidePassIcon = Icons.visibility_off;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: widget.color,
      elevation: 1,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.only(right: 12.0),
        child: TextFormField(

          onSaved: (value) {
            widget.onSave!(value!);
          },
          obscureText: hidePass,
            style:  TextStyle(fontSize: MediaQuery.of(context).size.width * .04),

            decoration: InputDecoration(
            suffixIcon: IconButton(
              icon: Icon(hidePassIcon),
              onPressed: () {
                setState(() {
                  if (hidePass) {
                    hidePass = false;
                    hidePassIcon = Icons.visibility;
                  } else {
                    hidePass = true;
                    hidePassIcon = Icons.visibility_off;
                  }
                });
              },
            ),
            border: InputBorder.none,
            labelText: widget.lable,
            labelStyle: TextStyle(
              fontSize: MediaQuery.of(context).size.width * .035,
            ),
            icon: Icon(Icons.lock_outline),
          ),
          keyboardType: TextInputType.visiblePassword,
          validator: (value) {
            if (value!.isEmpty)
              return "من فضلك إدخل كلمة المرور";
            else if (value.length < 8)
              return "كلمة المرور يجب الٌا تقل من ثمانية احرف";
          },
        ),
      ),
    );
  }
}
