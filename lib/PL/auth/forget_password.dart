import 'package:clinic_admin/PL/utilities/custom_button.dart';
import 'package:clinic_admin/PL/utilities/custom_textfield.dart';
import 'package:clinic_admin/constants.dart';
import 'package:flutter/material.dart';

class ForgetPassword extends StatefulWidget {
  @override
  _ForgetPasswordState createState() => _ForgetPasswordState();
}

class _ForgetPasswordState extends State<ForgetPassword> {
  String? _txtUsername;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(

        body: Container(
          child: Stack(
            children: <Widget>[
              backgroundImage()!,Form(
                key: _formKey,
                child: Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: MediaQuery.of(context).size.width * .1),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: MediaQuery.of(context).size.height*.2,),
                       logoImage(width: 120,height: 120.0)!,
                        Text(
                          "نسيت كلمة المرور؟",
                          style: TextStyle(
                            fontSize: 18.0,
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          "من فضلك إدخل اسم المستخدم \nونحن سوف نرسل لك رابط لإستعادة حسابك",
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.05),
                        CustomTextField(
                            icon: Icons.person,
                            onSave: (value){
                              setState(()=>_txtUsername=value);
                            },

                            lable: "اسم المستخدم"),
                        SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07),
                        CustomButton(
                            color: [
                              primaryColor,
                              Color(0xFF0D47A1),
                            ],
                            text: "إستمرار",
                            onPress: () => onPress(),
                            textColor: Colors.white)
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  onPress() {
    if (_formKey.currentState!.validate()) {
    _formKey.currentState!.save();
    print(_txtUsername);
    }
  }
}
