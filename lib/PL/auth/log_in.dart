import 'package:clinic_admin/PL/utilities/custom_button.dart';
import 'package:clinic_admin/PL/utilities/custom_text.dart';
import 'package:clinic_admin/PL/utilities/custom_textfield.dart';
import 'package:clinic_admin/PL/utilities/password_text_field.dart';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:clinic_admin/PL/auth/forget_password.dart';
class LogIn extends StatefulWidget {

  @override
  _LogInState createState() => _LogInState();
}

class _LogInState extends State<LogIn> {
  final _formKey = GlobalKey<FormState>();
  String? _txtUsername;
  String? _txtPassword;


  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: Container(
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    backgroundImage()!,
                    Form(
                      key: _formKey,
                      child: AnnotatedRegion<SystemUiOverlayStyle>(
                        value: SystemUiOverlayStyle.light,
                        child: GestureDetector(
                          onTap: () => FocusScope.of(context).unfocus(),
                          child: Container(
                            height: double.infinity,
                            child: SingleChildScrollView(
                              physics: AlwaysScrollableScrollPhysics(),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20.0, vertical: 40.0),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  logoImage(width:120.0,height:120.0)!,
                              SizedBox(height: 20.0),
                              CustomText(text: "نقادة سيستم | Naqada System",fontSize: 18,alignment: Alignment.center,),
                              CustomText(text: "تطبيق الدكتور",fontSize: 16,alignment: Alignment.center,color: Colors.grey,),
                              SizedBox(height: 40.0),
                              user.isLoading?loadingWidget()!:  dataColumn(user)
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    )
                  ],
                ),
              ),
      ),
    );
  }

  Widget dataColumn(UserProvider user){
    return Column(children: [

      CustomTextField(

          icon: Icons.person,
          onSave: (value){
            setState(()=>_txtUsername=value);
          },

          lable: "اسم المستخدم"),
      SizedBox(height: 15.0),
      PasswordTextField(
        lable: "كلمة المرور",
        onSave: (value){
          setState(()=>_txtPassword=value);
        },),
      SizedBox(height: 15.0),
     // __buildForgetPasswordWidget(),
      SizedBox(height: 15.0),
      CustomButton(
          color: [
            primaryColor,
            Color(0xFF0D47A1),
          ],
          text: "تسجيل الدخول",
          onPress: ()=>onPressLogIn(user),
          textColor: Colors.white),
      SizedBox(height: 30.0),
      __buildConnectUsWidget()
    ],);
  }

  Widget __buildForgetPasswordWidget() {
    return Container(
      alignment: Alignment.centerRight,
      child: FlatButton(
        child: Text(
          "هل نسيت كلمة المرور؟",
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * .04,
              color: Colors.blue),
        ),
        onPressed: () {
          goTo(context: context,to:ForgetPassword());
        },
      ),
    );
  }

  Widget __buildConnectUsWidget() {
    return Container(
      child: FlatButton(
        child: Text(
          "للتواصل إضغط هنا",
          style: TextStyle(
              fontSize: MediaQuery.of(context).size.width * .04,
              color: Colors.blue),
        ),
        onPressed:()async=> await launch("tel://01146906776"),
      ),
    );
  }
  onPressLogIn(UserProvider user)async{
    if(_formKey.currentState!.validate()){
      _formKey.currentState!.save();

      if(!await user.signIn(_txtUsername!, _txtPassword!))
        Fluttertoast.showToast(msg: user.error!);

    }
  }

}
