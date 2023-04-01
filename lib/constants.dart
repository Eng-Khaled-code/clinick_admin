
import 'package:clinic_admin/provider/drawer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';
 const Color primaryColor=Color(0xff1976D2);
///methods
goTo({@required BuildContext? context, @required Widget? to}) {
  Navigator.push(context!, MaterialPageRoute(builder: (context) => to!));
}

onBack(BuildContext context){

  DrawerProvider drawerProvider=Provider.of<DrawerProvider>(context,listen: false);
  drawerProvider.setPage('home');
}

Widget? loadingWidget(){
  return Shimmer.fromColors(
      period: Duration(milliseconds: 1000),
      baseColor: primaryColor,
      highlightColor: Colors.pink,child:Center(child: CircularProgressIndicator(color: primaryColor,),));
}


Widget? backgroundImage() {
  return Container(
    height: double.infinity,
    width: double.infinity,
    child: Opacity(
        opacity: 0.5,
        child: Image.asset(
          'assets/images/splach_bg.png',
          fit: BoxFit.fill,
        )),
  );
}
  Widget? logoImage({double? width,double? height}) {
  return Container(width: width,
      height: height,
      child: Image.asset("assets/images/icon.png", fit: BoxFit.fill,));
}




