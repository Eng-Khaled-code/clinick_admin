import 'dart:convert';
import 'package:clinic_admin/PL/notification/notify_card.dart';
import 'package:clinic_admin/PL/utilities/custom_notify.dart';
import 'package:clinic_admin/PL/utilities/custom_text.dart';
import 'package:clinic_admin/PL/utilities/drawer.dart';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/model/notify_model.dart';
import 'package:clinic_admin/provider/notify_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class NotificationPage extends StatelessWidget {

  SharedPreferences? prefs;

  final _key=GlobalKey<ScaffoldState>();
  initalizeShared(BuildContext context)async{
    prefs=await SharedPreferences.getInstance();

  }
  @override
  Widget build(BuildContext context) {
    initalizeShared(context);
    NotifyProvider notifyProvider=Provider.of<NotifyProvider>(context);

    return    Directionality(textDirection: TextDirection.rtl,
        child: WillPopScope(
          onWillPop: ()async{
            if(_key.currentState!.isDrawerOpen)
              Navigator.pop(context);
            else
              onBack(context);
            return false;
          },
          child: Scaffold(
            appBar:_appbar(context,notifyProvider),
              key: _key,
              backgroundColor: Colors.grey[300],
              drawer: CustomDrawer(),

              body: RefreshIndicator(
          onRefresh: ()async{
            notifyProvider.refresh();
          },
          child: Container(
              height: double.infinity,

              child:FutureBuilder<List>(
              future: notifyProvider.loadNotifyList(),
              builder:(context,snapshot)
                  =>!snapshot.hasData
                  ?
              loadingWidget()!
                  :
              snapshot.data!.length==0
                 ?
              noDataCard("لا توجد إشعارات","nodata",context)
                 :
              ListView.builder(
              itemCount: snapshot.data!.length,
                  itemBuilder:(context,position){
                  Map<String, dynamic> data = jsonDecode(snapshot.data![position]);
                  print(data.toString());
                NotifyModel notifyModel=NotifyModel.fromSnapshot(data);
                Color? seenColor=prefs!.getString(notifyModel.messageId!)==null||prefs!.getString(notifyModel.messageId!)=="0"?Colors.blue[100]:Colors.transparent;
              return NotifyCard(model:notifyModel,seenColor:seenColor);})
    )),
      )),
        ));

  }

  AppBar _appbar(BuildContext context,NotifyProvider notifyProvider){
    return AppBar(
        leading: Container(margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor),color: Colors.white,),

          child: IconButton(icon:Icon(Icons.menu,color: primaryColor,size: 20,),onPressed: ()=>_key.currentState!.openDrawer(),
        )),
    backgroundColor:Colors.grey[300] ,
    title: CustomText(text:"الإشعارات",fontWeight: FontWeight.bold,fontSize: 18,)
    ,actions: [
    Container(margin: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor),color:primaryColor,),
    child: CustomNotifyWidget(
    icon: Icons.notifications_none,
    page:'noti',
    onPress: () async {
    //prefs!.setString("last_date", DateTime.now().toString());
    //await notifyProvider.loadNotifyCount();
    },
    count: 0),),
    Container(
    margin: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(
    shape: BoxShape.circle,
    border: Border.all(color:primaryColor)
    ,color: Colors.white),
    child: IconButton(
    icon:Icon(
    Icons.arrow_forward,
    color: primaryColor,
    size: 20,),
    onPressed:  ()=>onBack(context),)),

    ],);
  }
  noDataCard(String message,type,BuildContext context){
    return ListView(
      children: [
        Container(
          height:MediaQuery.of(context).size.height*.85,
          padding: const EdgeInsets.all(10),
          margin: const EdgeInsets.all(10),
          decoration: BoxDecoration(      color:Colors.white,
              border: Border.all(color:primaryColor),borderRadius: BorderRadius.circular(10)),
          child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center, children: [
            Icon(Icons.notifications_none,size: 50,color: primaryColor),
            SizedBox(height: 15.0),
            CustomText(text: message,maxLine: 2,)]
            ,),
        ),
      ],
    );
  }



}