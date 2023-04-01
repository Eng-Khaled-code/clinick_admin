import 'dart:io';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/provider/drawer_provider.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'custom_alert_dialog.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    final user = Provider.of<UserProvider>(context);
    final drawerProvider = Provider.of<DrawerProvider>(context);

    return Drawer(
      child: Container(
        child: Stack(
          alignment: Alignment.center,
          children: <Widget>[
           backgroundImage()!,
            ListView(
              children: <Widget>[
                drawerHeader(user, height),
                drawerBodyTile(Icons.home, Colors.blue, "الرئيسية",
                        () {
                      drawerProvider.setPage("home");

                }
                ),
                drawerBodyTile(Icons.settings, Colors.blue, "تحديث البيانات",  () {
                  drawerProvider.setPage("profile");
                }

                ),
                drawerBodyTile(Icons.library_books, Colors.blue, "الحجوزات",  () {
                  drawerProvider.setPage("booking");
                }),


                    drawerBodyTile(Icons.notifications_none, Colors.blue, "الاشعارات",  () {
                  drawerProvider.setPage("noti");
                }

                ),
                drawerBodyTile(Icons.star_rate, Colors.blue, "التقييمات",  () {
                  drawerProvider.setPage("rate");
                }
                ),
                drawerBodyTile(Icons.call, Colors.blue, " للتواصل",  () async=> await launch("tel://01146906776"),),
                Divider(
                  color: Colors.blueAccent,
                ),

                drawerBodyTile(Icons.arrow_back, Colors.red, "تسجيل الخروج",
                    () {
                  showDialog(
                      context: context,
                      builder: (context) => CustomAlertDialog(
                            title: "تنبيه",
                            onPress: () => logOut(user,context),
                            text: "هل تريد تسجيل الخروج بالفعل",
                          ));
                  //user.signOut();
                }),
              ],
            ),
          ],
        ),
      ),
    );
  }

  logOut(UserProvider user,BuildContext context) async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        Navigator.pop(context);
        SharedPreferences? pref=await SharedPreferences.getInstance();

        await pref.setString("loged_in", "loged_in");
        Navigator.pop(context);
        user.checkLogIn();

      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "تاكد من اتصال الانترنت");
    }
  }

  drawerHeader(UserProvider user, height) {
    return UserAccountsDrawerHeader(
      currentAccountPicture: CircleAvatar(backgroundImage: NetworkImage(user.userInformation!.imageUrl!),),
            accountEmail: Text(
              user.userInformation!.userName!,
              style: TextStyle(color: Colors.white),
            ),
            accountName: Text(user.userInformation!.doctorName!,
                style: TextStyle(color: Colors.white)),

          );
  }

  Widget drawerBodyTile(
      IconData icon, Color color, String text, Function()? onTap) {
    return ListTile(
      title: Text(text),
      leading: Icon(
        icon,
        color: color,
      ),
      onTap: onTap,
    );
  }
}
