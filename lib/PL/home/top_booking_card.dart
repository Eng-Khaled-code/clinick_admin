import 'dart:io';

import 'package:clinic_admin/PL/utilities/custom_alert_dialog.dart';
import 'package:clinic_admin/PL/utilities/custom_button.dart';
import 'package:clinic_admin/PL/utilities/custom_text.dart';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/model/booking_model.dart';
import 'package:clinic_admin/provider/booking_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

class TopBookingCard extends StatelessWidget {
  final BookingModel? model;
  final int? number;
  final int? index;
  late  final int? listLength;
  final String? token;
  TopBookingCard({this.model,this.number,this.index,this.listLength,this.token});

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider=Provider.of<BookingProvider>(context);
    //print(bookingProvider.secondBookingIndex);

    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child:number==1?  Material(
        elevation: 2,
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,

            children: [

              Container(
                alignment: Alignment.topRight,
              padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
              decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: primaryColor),
              child: CustomText(text:model!.type!,color: Colors.white,),),
        Shimmer.fromColors(
                  period: Duration(milliseconds: 1000),
                  baseColor: primaryColor,
                  highlightColor: Colors.pink,child:CustomText(text:" يوجد حاليا بداخل حجرةالكشف"))
        ,Container(
        padding: EdgeInsets.all(5.0),
        decoration: BoxDecoration(

            color: primaryColor,
            borderRadius:
            BorderRadius.circular(
                4.0)) ,
        alignment:Alignment.topLeft,
        child: CustomText(
            text:model!.number!.toString(),
        color: Colors.white,
      ),
      )
            ],
          ),
              Shimmer.fromColors(
                period: Duration(milliseconds: 1000),
                baseColor: primaryColor,
                highlightColor: Colors.pink,child: columnData(),
          ),
    Row(mainAxisAlignment: MainAxisAlignment.center,children:[ Text("لإلغاء الطلب إضغط ",style: TextStyle(color: Colors.black) )
    ,GestureDetector(
    child:Text(" هنا ",
    style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: Colors.green,decoration: TextDecoration.underline))
    ,onTap: ()=>showDialogReasonDialog(context),)
    ]),

       Padding(
         padding: const EdgeInsets.all(20.0),
         child: CustomButton(color: [
      primaryColor,
      Color(0xFF0D47A1),
      ],
      text: model!.type=="كشف"?"إنهاء و تحديد موعد الإعادة":"إنهاء",
      onPress: (){

           if(model!.type=="كشف")
           showFinishDialogWithDate(context,);
           else
           showFinishDialogWithNoDate(context, bookingProvider);
      },
      textColor: Colors.white),
       )

            ],
          )

      ):Material(
    elevation: 2,
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),

    child: Column(
      children: [
    Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,

    children: [
        Container(
    padding: EdgeInsets.symmetric(horizontal: 10,vertical: 5),
    decoration: BoxDecoration(borderRadius: BorderRadius.circular(10),color: primaryColor),
    child: CustomText(text:model!.type!,color: Colors.white,),),


    Shimmer.fromColors(
        period: Duration(milliseconds: 1000),
        baseColor: primaryColor,
        highlightColor: Colors.pink,child:CustomText(text:" الشخص التالي")),Container(
    padding: EdgeInsets.all(5.0),
    decoration: BoxDecoration(

    color: primaryColor,
    borderRadius:
    BorderRadius.circular(
    4.0)) ,
    alignment:Alignment.topLeft,
    child: CustomText(
    text:model!.number!.toString(),
    color: Colors.white,
    ),
    )
      ],
    ),
        columnData(),
   Padding(
     padding: const EdgeInsets.all(8.0),
     child: Wrap(
      alignment: WrapAlignment.center,
      children:[ Text("إذا كان المريض غير موجود إضغط ",style: TextStyle(color: Colors.black) )
     ,GestureDetector(
      child:
      Text(" التالي ",
      style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: primaryColor,decoration: TextDecoration.underline))
      ,onTap: (){
      print("next "+index!.toString());


      if(listLength! > index!+1 && index!+1 != int.tryParse(bookingProvider.firstBookingIndex))
                bookingProvider.setSecondCardIndex((index! +1).toString());
     else if(listLength! > index!+1 && index!+1 == int.tryParse(bookingProvider.firstBookingIndex))
        {
                if(listLength! > index!+2)
                   bookingProvider.setSecondCardIndex((index! +2).toString());
                else
                   Fluttertoast.showToast(msg:"هذا المريض هو اخر واحد في الصف");
        }

      else
        Fluttertoast.showToast(msg:"هذا المريض هو اخر واحد في الصف");
      }
      ,)
     ,Text(" أو اضغط ",style: TextStyle(color: Colors.black))
      ,GestureDetector(
      child:
      Text(" السابق ",
      style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18,color: primaryColor,decoration: TextDecoration.underline))
      ,onTap: (){
        if(index!>0)
        {
          print(index.toString()+" my");
             if(index!-1 != int.tryParse(bookingProvider.firstBookingIndex))
                bookingProvider.setSecondCardIndex((index! -1).toString());
             else if(index!-2>=0 )
                  bookingProvider.setSecondCardIndex((index! -2).toString());
             else
                  Fluttertoast.showToast(msg:"هذا المريض هو الاول في الصف");


        }
        else
          Fluttertoast.showToast(msg:"هذا المريض هو الاول في الصف");
        }
      ,)
      ,Text("للشخص الذي اتي متاخر عن دوره",style: TextStyle(color: Colors.black))
     ]
      ),
   ),



   bookingProvider.firstBookingIndex=="noOne"? Padding(
    padding: const EdgeInsets.all(20.0),
    child: CustomButton(color: [
    primaryColor,
    Color(0xFF0D47A1),
    ],
    text: "إدخال الي حجرة الكشف",
    onPress: (){

    showDialog(
    context: context,
    builder: (context){
    return CustomAlertDialog(
    title: "تنبيه",
    onPress: (){
      String? second=listLength! > (index!+1)?(index! +1).toString():(index!)>0?(index!-1).toString():"noOneRemain";

    bookingProvider.setSecondCardIndex(second);
    bookingProvider.setFirstCardIndex(index.toString());
    Navigator.pop(context);
    },
    text:"هل تريد إدخال هذا الشخص الي حجرة الكشف" ,
    );});

    },
    textColor: Colors.white),
    ):Container()

    ],
    )
    )
    );
  }

  Widget columnData(){

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center
    ,children: [

      CustomText(text:model!.patientName!,color: primaryColor,fontSize: 18,fontWeight: FontWeight.bold,alignment: Alignment.center,),
      CustomText(text:model!.painSummary!,color:  Colors.grey,alignment: Alignment.center,),
      SizedBox(height: 20),

      ]),
  );

  }

  showDialogReasonDialog(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _controller = TextEditingController();
    showDialog(
        barrierDismissible: false,
        context: context,

        builder: (context) {
          BookingProvider bookingProvider= Provider.of<BookingProvider>(context);

          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              scrollable: true,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10)),
              title: Text("السبب ؟"),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  validator: (String? value) {
                if (value!.isEmpty)
                return "يجب ان تدخل سبب رفض هذا الحجز";
                },
                  decoration: InputDecoration(
                      labelText: "السبب",
                      labelStyle: TextStyle(fontSize: 13)),
                ),
              ),
              actions: <Widget>[
                bookingProvider.isLoading?Container(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 0.7,
                    )):TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {

    try {
    final result = await InternetAddress.lookup(
    'google.com');
    if (result.isNotEmpty &&
    result[0].rawAddress.isNotEmpty) {
                      if (!await bookingProvider
                          .refuseBooking(bookingId: model!.bookingId,token: token,note: _controller.text))
                      Fluttertoast.showToast(msg: bookingProvider.error!);
                      else {

                      Fluttertoast.showToast(msg: "تم  رفض الحجز بنجاح");
                      try{

                      bookingProvider.setFirstCardIndex("noOne");

                      if(int.tryParse(bookingProvider.secondBookingIndex)! > 0){
                      bookingProvider.decreaseSecondCardByOne();
                      }}catch(ex){

                      }

                      Navigator.pop(context);
                      }

                      }
          } on SocketException catch (_) {
          Fluttertoast.showToast(
          msg: "تأكد من إتصالك بالإنترنت",
          toastLength: Toast.LENGTH_LONG);
          }
        }
                    },
                    child: Text("إرسال الرفض",
                        style:
                        TextStyle(fontSize: 13, color: Colors.red))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("إلغاء", style: TextStyle(fontSize: 13))),
              ],
            ),
          );
        });

  }

  showFinishDialogWithNoDate(BuildContext context,BookingProvider bookingProvider){

    showDialog(
        context: context,
        builder: (context){
          return CustomAlertDialog(
            title: "تنبيه",
            onPress: () async {

            try {
              final result = await InternetAddress.lookup(
                  'google.com');
              if (result.isNotEmpty &&
                  result[0].rawAddress.isNotEmpty) {

              if(! await bookingProvider.finishBooking(token: token,bookingId: model!.bookingId,date: "no"))
                Fluttertoast.showToast(msg: bookingProvider.error!);
              else{
                Fluttertoast.showToast(msg: "تم الكشف بنجاح يرجي ابلاغ المريض بتقييم الدكتور من علي النظام الرئيسي");
                bookingProvider.setFirstCardIndex("noOne");

                try{

                  if(int.tryParse(bookingProvider.secondBookingIndex)! > 0){
                    bookingProvider.decreaseSecondCardByOne();
                  }}catch(ex){

                }
                Navigator.pop(context);

              }}
        } on SocketException catch (_) {
      Fluttertoast.showToast(
          msg: "تأكد من إتصالك بالإنترنت",
          toastLength: Toast.LENGTH_LONG);
    }

            },
            text:"هل انتهي الكشف بالفعل" ,
          );});
  }

  showFinishDialogWithDate(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _dateController = TextEditingController();

    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          BookingProvider bookingProvider=Provider.of<BookingProvider>(context);
          return Directionality(
            textDirection: TextDirection.rtl,
            child: AlertDialog(
              scrollable: true,shape: RoundedRectangleBorder(

                borderRadius: BorderRadius.circular(10)),
              title: Text("تحديد موعد الإعادة"),
              content: Form(
                key: _formKey,
                child: TextFormField(
                  onTap: ()=>_showDatePacker(_dateController,context,bookingProvider),
                  readOnly: true,
                  controller: _dateController,
                  validator: (String? value) {
                if (value!.isEmpty)
                return "يجب ان تدخل تاريخ الإعادة";
                },
                  decoration: InputDecoration(
                      labelText: "موعد الإعادة الذي سوف ياتي به المريض",
                      labelStyle: TextStyle(fontSize: 12)),
                ),
              ),
              actions: <Widget>[
                bookingProvider.isLoading?Container(
                    width: 17,
                    height: 17,
                    child: CircularProgressIndicator(
                      strokeWidth: 0.7,
                    )):TextButton(
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                      try {
                      final result = await InternetAddress.lookup(
                      'google.com');
                      if (result.isNotEmpty &&
                      result[0].rawAddress.isNotEmpty) {

                          if(! await bookingProvider.finishBooking(token: token,bookingId: model!.bookingId,date: _dateController.text))
                          Fluttertoast.showToast(msg: bookingProvider.error!);
                          else{
                          Fluttertoast.showToast(msg: "تم الكشف بنجاح يرجي ابلاغ المريض بتقييم الدكتور من علي النظام الرئيسي");
                          bookingProvider.setFirstCardIndex("noOne");

                          try{

                          if(int.tryParse(bookingProvider.secondBookingIndex)! > 0){
                      bookingProvider.decreaseSecondCardByOne();
                      }}catch(ex){

                          }
                          Navigator.pop(context);

                      }
                      }
                      } on SocketException catch (_) {
                      Fluttertoast.showToast(
                      msg: "تأكد من إتصالك بالإنترنت",
                      toastLength: Toast.LENGTH_LONG);
                      }
                      }
                    },
                    child: Text("موافق",
                        style:
                        TextStyle(fontSize: 13, color: Colors.red))),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("إلغاء", style: TextStyle(fontSize: 13))),
              ],
            ),
          );
        });

  }

  _showDatePacker(TextEditingController dateController,BuildContext context,BookingProvider bookingProvider) async{

    final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2050,1,1));

    if (picked != null) {

    String date = picked.year.toString()+ "-"+ picked.month.toString()+"-"+picked.day.toString();
    String thisDay=DateTime.now().year.toString()+ "-"+DateTime.now().month.toString()+"-"+DateTime.now().day.toString();
    if(date==thisDay)
      Fluttertoast.showToast(msg: "لا يمكن ان تكون الإعادة في نفس يوم الحجز");
      else
      dateController.text=date;

    bookingProvider.refresh();
    }
  }
}
