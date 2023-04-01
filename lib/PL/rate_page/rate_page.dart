import 'package:clinic_admin/PL/rate_page/rate_card.dart';
import 'package:clinic_admin/PL/utilities/custom_text.dart';
import 'package:clinic_admin/PL/utilities/drawer.dart';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/model/rate_model.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';


class RatePage extends StatelessWidget {

  final String? doctorId;
  RatePage({this.doctorId});
  final _key=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    UserProvider user=Provider.of<UserProvider>(context);
    bool noData=user.userInformation!.ratings==null||user.userInformation!.ratings!.length==0;
    return Directionality(
    textDirection: TextDirection.rtl,
      child:WillPopScope(
    onWillPop: ()async{
    if(_key.currentState!.isDrawerOpen)
      Navigator.pop(context);
    else
    onBack(context);
    return false;
    }, child:Scaffold(
          backgroundColor: Colors.grey[300],
key: _key,
    drawer: CustomDrawer(),

    appBar: AppBar(flexibleSpace: Container(child: backgroundImage()!,),backgroundColor: Colors.grey[300],title: CustomText(text:"التقييمات",color:primaryColor,fontWeight: FontWeight.bold,),automaticallyImplyLeading: false,
    leading: Container(margin: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor),color: Colors.white,),

    child: IconButton(icon:Icon(Icons.menu,color: primaryColor,size: 20,),onPressed: ()=>_key.currentState!.openDrawer() ,
    )),
    actions:[Container(margin: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor)),
    child: IconButton(icon:Icon(Icons.arrow_forward,color:primaryColor,size: 20,),onPressed:  ()=>onBack(context))) ,]
    ),
          body:  Stack(children: <Widget>[
        backgroundImage()!, RefreshIndicator(
         onRefresh: ()async{
           await user.loadUserData(doctorId: user.userInformation!.doctorId,token: user.userInformation!.token);
        },
            child: Container(child :
    user.isLoading
    ?
    loadingWidget():noData
    ?
    noDataCard("لا توجد تقييمات")
          :

        ListView.builder(itemCount: user.userInformation!.ratings!.length,itemBuilder: (context,position){
              return RateCard(model: RateModel.fromSnapshot(
              user.userInformation!.ratings![position]
                 ));

            }),
        ),
          )])),
      ),
    );
  }

  noDataCard(String message){
    return Container(
      padding: const EdgeInsets.all(10),
      height: 300,
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(border: Border.all(color:primaryColor),borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.emoji_emotions,size: 50,color: primaryColor),
        SizedBox(height: 15.0),
        CustomText(text: message)]
        ,),
    );
  }
}
