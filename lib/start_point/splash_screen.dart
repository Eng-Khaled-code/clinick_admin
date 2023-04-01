import 'dart:io';

import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class SplashScreen extends StatefulWidget {
final String? type;

SplashScreen({this.type});

@override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  String navigate='';

  updatingData(UserProvider userProvider)async{
   if(widget.type=="check_data")
   {

     SharedPreferences pref=await SharedPreferences.getInstance();

   String doctorId= pref.getString("doctor_id")==null?'load':pref.getString("doctor_id")!;
   print(doctorId);


    try {
    final result = await InternetAddress.lookup(
    'google.com');
    if (result.isNotEmpty &&
    result[0].rawAddress.isNotEmpty){


    userProvider.getToken().then((token)async{

    print(token);
    if(doctorId!='load'){



    await userProvider.updateToken(doctorId: doctorId,token:token).then((tokenUpdated)async{

    if(tokenUpdated){
    print("updated");

    await userProvider.loadUserData(doctorId :doctorId,token: token).then((value){
if(userProvider.userInformation != null){
    if(userProvider.userInformation!.isInMySystem=="1"){


    pref.setString("loged_in","check_data");
    userProvider.setPage("home");
    Fluttertoast.showToast(msg: "تم تسجيل الدخول بنجاح");


    }
    else
    setState(()=>navigate="no");

    }

    });
    }
    else
    setState(()=>navigate="no");



    });

    }


    });
    } } on SocketException catch (_) {
    Fluttertoast.showToast(msg: "تأكد من إتصالك بالإنترنت", toastLength: Toast.LENGTH_LONG);

    }


   }

  }
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    final UserProvider userProvider=Provider.of<UserProvider>(context);
    updatingData(userProvider);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SingleChildScrollView(
          child: Container(
            height: 800,
            child: Stack(
              children: <Widget>[
                Container(
                  width: width,
                  height: height,
                  child: Container(),
                ),
               backgroundImage()!,
                Container(
                  child: Center(

                      child: Column(
                      children: [
                          MediaQuery.of(context).orientation==Orientation.portrait?SizedBox(height: 100):   SizedBox(height: 20),
                    logoImage(width:120.0,height:120.0)!,
                        SizedBox(height: 30),
                    Shimmer.fromColors(
                      period: Duration(milliseconds: 1000),
                      baseColor: primaryColor,
                      highlightColor: Colors.pink,child:   Column(
                        children: [
                          Text(
                              "نقادة سيستم | الدكتور",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: width * .05,
                                  fontWeight: FontWeight.bold,
                                  ),
                            )
                          ,widget.type=="splach"? Container():Column(
                            children: [
                              SizedBox(height: 10,) ,
                      Text(
                          navigate=="no"?"إنتظر لحظة او اعد فتح التطبيق من جديد وتاكد من اتصال الانترنت لديك وإذا استمرت المشكلة يرجي التواصل مع مالك التطبيق":"جاري تحديث البيانات...",
                        textAlign: TextAlign.center,
                    style: TextStyle(
                    fontSize: width * .045,
                    ),
                  ),
                      SizedBox(height: 10,) ,

                      navigate=="no"?Container(): loadingWidget()!
                  ],
                          )

                        ],
                      )     )

                      ],
                    ),
                    ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
