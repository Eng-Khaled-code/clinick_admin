import 'package:clinic_admin/PL/booking/booking_controller.dart';
import 'package:clinic_admin/PL/home/home_page.dart';
import 'package:clinic_admin/PL/notification/notifications.dart';
import 'package:clinic_admin/PL/profile/profile_page.dart';
import 'package:clinic_admin/PL/rate_page/rate_page.dart';
import 'package:clinic_admin/provider/drawer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
class HomeController extends StatelessWidget {
  final String? doctorId;

  HomeController(this.doctorId);

  @override
  Widget build(BuildContext context) {
    final drawerProvider = Provider.of<DrawerProvider>(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child:mainScreen(drawerProvider.page)
    );
  }

  Widget mainScreen(String page){
    switch(page){
      case "rate":
        return RatePage(doctorId:doctorId );
      case "noti":
        return NotificationPage();
      case "profile":
        return ProfilePage();
      case "booking":
        return BookingController();
      default :
        return HomePage();


    }

  }

}
