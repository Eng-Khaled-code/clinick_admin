import 'package:clinic_admin/PL/auth/log_in.dart';
import 'package:clinic_admin/PL/home/home_controller.dart';
import 'package:clinic_admin/PL/home/home_page.dart';
import 'package:clinic_admin/PL/notification/book_details.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:clinic_admin/start_point/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

class ScreenController extends StatefulWidget {
  @override
  _ScreenControllerState createState() => _ScreenControllerState();
}

class _ScreenControllerState extends State<ScreenController> {



  @override
  Widget build(BuildContext context) {

    final user = Provider.of<UserProvider>(context);

    //checkLogIn();
        switch(user.page){
          case 'home':
            return HomeController(user.userInformation!.doctorId);
          case 'loged_in':
            return LogIn();
          default :
            return SplashScreen(type:user.page);

        }
  }
}
