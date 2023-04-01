import 'dart:io';

import 'package:clinic_admin/PL/utilities/custom_alert_dialog.dart';
import 'package:clinic_admin/PL/utilities/custom_button.dart';
import 'package:clinic_admin/PL/utilities/custom_text.dart';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'custom_dropdown_button.dart';

class WorkDays extends StatefulWidget {
  final List? workDaysList;
  final String? token;
  final String? doctorId;

  static String selectedDay="السبت";

  WorkDays({this.workDaysList,this.token,this.doctorId});

  @override
  _WorkDaysState createState() => _WorkDaysState();
}

class _WorkDaysState extends State<WorkDays> {

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(
    child:Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
      Row(
    mainAxisAlignment:MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CustomText(text:"مواعيد العمل" ,fontWeight: FontWeight.bold,fontSize: 16,alignment: Alignment.topRight,),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: CustomButton(textColor: Colors.white,width: 120,onPress: (){
              setState(()=>WorkDays.selectedDay="السبت");

              showDialogReasonDialog(context,"إضافة","","","");

            },text: "إضافة موعد",color: [ primaryColor,
            Color(0xFF0D47A1),],),
          )
        ],
      ),
        Container(
            padding: const EdgeInsets.all(8.0),
            width: double.infinity,
            height: 200,
            child: widget.workDaysList==null?loadingWidget()!:widget.workDaysList!.length==0?noDataCard():

            ListView.builder(shrinkWrap: true,scrollDirection: Axis.horizontal,itemCount: widget.workDaysList!.length,itemBuilder: (context,position){

            return Item(day: widget.workDaysList![position]["DAY"],from:  widget.workDaysList![position]["FROM"],to:  widget.workDaysList![position]["TO"],itemId:  widget.workDaysList![position]["ID"]);

          })),
        ],
      )
    ));
  }

  Widget Item({String? day,String? from ,String? to,String? itemId}){

    return  Material(
      borderRadius: BorderRadius.circular(10.0),
      elevation: 1,
      child: Container(
          padding: EdgeInsets.only(top: 8.0),
        margin:const EdgeInsets.all(12.0),
        decoration:BoxDecoration(
          border: Border.all(color: primaryColor),
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            CustomText(text:day! ,fontWeight: FontWeight.bold,fontSize: 16,),
            CustomText(text:"من "+from!.substring(0,5)+"\n إلي "+to!.substring(0,5) ,color: Colors.grey,fontSize: 14,),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children:[ Padding(
          padding: const EdgeInsets.only(right: 4.0,bottom: 8.0),
          child: CustomButton(
              width: 80,
              color: [
                Color(0xFF1E88E5),
                Color(0xFF0D47A1),
              ],
              text: "تعديل",
              onPress:(){
                setState(()=>WorkDays.selectedDay=day);
                showDialogReasonDialog(context,"تحديث",from.substring(0,5),to.substring(0,5),itemId!);},
              textColor: Colors.white),
        ),Padding(
          padding: const EdgeInsets.only(right: 4.0,bottom: 8.0,left: 4.0),
          child: CustomButton(
              width: 80,

              color: [
                Color(0xFF1E88E5),
                Color(0xFF0D47A1),
              ],
              text: "حذف",
              onPress: (){

                showDialog(
                    context: context,
                    builder: (context){
                      UserProvider userProvider=Provider.of<UserProvider>(context);

                       return Directionality(
                      textDirection: TextDirection.rtl,
                      child: AlertDialog(
                      title: Text(
                      "تنبيه",
                      style: TextStyle(fontSize: 16),
                      ),
                      actions: [
                      TextButton(
                      onPressed: () {
                      Navigator.pop(context);
                      },
                      child: Text("إلغاء"))
                      ,userProvider.isLoading?Container(
                      width: 17,
                      height: 17,
                      child: CircularProgressIndicator(
                      strokeWidth: 0.7,
                      )):TextButton(onPressed: () async {
    try {
    final result = await InternetAddress.lookup(
    'google.com');
    if (result.isNotEmpty &&
    result[0].rawAddress.isNotEmpty) {
    if (!await userProvider
        .deleteWorkDay(dayId: itemId))
    Fluttertoast.showToast(msg: userProvider.error!);
    else {
    Navigator.pop(context);
    Fluttertoast.showToast(msg: "تمت الحذف بنجاح");
    await userProvider.loadUserData(doctorId: widget.doctorId,token: widget.token);

    }
    }
    } on SocketException catch (_) {
    Fluttertoast.showToast(msg: "تأكد من إتصالك بالإنترنت", toastLength: Toast.LENGTH_LONG);
    }


    }, child: Text("تأكيد"))
    ],
    content: Text(
    "هل تريد الحذف بالفعل",
    style: TextStyle(fontSize: 14, color: Colors.black54),
    ),
    ));});

              },
              textColor: Colors.white),
        )],
      )
          ],
        ),),
    );


  }

  noDataCard(){
    return  Material(
      borderRadius: BorderRadius.circular(10.0),

      elevation: 1,
      child: Container(

        margin:const EdgeInsets.all(12.0),
        padding: const EdgeInsets.all(8.0)
        ,width: 100,
        decoration:BoxDecoration(
            border: Border.all(color: primaryColor),
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10)),
        child:             CustomText(text:"لا توجد مواعيد حتي الان"),
      ),
    );
  }

  showDialogReasonDialog(BuildContext context,String type,String from,String to ,String dayId) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController toCon=TextEditingController(text: to);
    TextEditingController fromCon=TextEditingController(text: from);

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (BuildContext context2) {
          UserProvider userProvider=Provider.of<UserProvider>(context2);
          //userProvider.setTo(to);
         // userProvider.setFrom(from);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              scrollable: true,shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(10)),
              title: Text(type),
              content: Form(
                key: _formKey,
                child: Column(
                  children: [
                    CustomDropdownButton(),
                 TextFormField(
                      onTap: ()=>_showDatePacker(fromCon,context2,userProvider),
                      controller: fromCon,
                      readOnly: true,

                      validator: (String? value) {
                    if (value!.isEmpty)
                    return "موعد البداية";
                    },
                      decoration: InputDecoration(
                          labelText: "من",
                          labelStyle: TextStyle(fontSize: 13)),
                    ),
                    TextFormField(
                      onTap: ()=>_showDatePacker(toCon,context2,userProvider),
                      controller: toCon,
                      readOnly: true,
                      validator: (String? value) {
                    if (value!.isEmpty)
                    return "موعد الانتهاء";
                    },
                      decoration: InputDecoration(
                          labelText: "الي",
                          labelStyle: TextStyle(fontSize: 13)),
                    ),

                  ],
                ),
              ),
              actions: <Widget>[
                userProvider.isLoading?Container(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 0.7,
                    )):TextButton(
                    onPressed: () async {

                      if (_formKey.currentState!.validate()&&WorkDays.selectedDay!="") {


                      if( await updateField(userProvider:userProvider,dayId:dayId,from:fromCon.text,to:toCon.text,type:type,day:WorkDays.selectedDay))
                        {
                          Navigator.pop(context2);
                          await userProvider.loadUserData(doctorId: widget.doctorId,token: widget.token);
                        }


                      }
                    },
                    child: Text(type,
                        style:
                        TextStyle(fontSize: 13))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context2);
                    },
                    child: Text("إلغاء", style: TextStyle(fontSize: 13, color: Colors.red))),
              ],
            ),
          );
        });

  }

  _showDatePacker(TextEditingController timeController,BuildContext context,UserProvider user) async{

    TimeOfDay _startTime = timeController.text == ""?
    TimeOfDay(hour:DateTime.now().hour,minute: DateTime.now().minute)
    :
    TimeOfDay(hour:int.parse(timeController.text.split(":")[0]),minute: int.parse(timeController.text.split(":")[1]));

    final TimeOfDay? picked = await showTimePicker(
    initialTime: _startTime,
    context: context,
    );

    if (picked != null) {
    timeController.text=picked.hour.toString()+":"+picked.minute.toString();
    user.refresh();
    }


  }

  Future<bool> updateField({String? from,String? to,String?dayId, UserProvider? userProvider,String? type,BuildContext? context2,String? day}) async {
    if (type == "إضافة") {
      if (!await userProvider!
          .addWorkDay(from: from,to:to,day:day )){
    Fluttertoast.showToast(msg: userProvider.error!);
      return false;
      }
    else {
    Fluttertoast.showToast(msg: "تمت الإضافة بنجاح");
    return true;

    }
    }
    else {
    if (!await userProvider!
        .updateWorkDay(dayId: dayId,from:from,to:to,day: day)){
    Fluttertoast.showToast(msg: userProvider.error!);
    return false;
    }
    else {
    Fluttertoast.showToast(msg: "تم التعديل بنجاح");
    return true;

    }
    }
  }
}
