import 'dart:io';

import 'package:clinic_admin/PL/utilities/custom_button.dart';
import 'package:clinic_admin/PL/utilities/custom_text.dart';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/model/booking_model.dart';
import 'package:clinic_admin/provider/booking_provider.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:timeago/timeago.dart' as timeago;

class BookingCard extends StatefulWidget {
  final BookingModel? model;
  final String? token;
  BookingCard({this.model,this.token});

  @override
  _BookingCardState createState() => _BookingCardState();
}

class _BookingCardState extends State<BookingCard> {
  @override
  Widget build(BuildContext context) {
    final difference = DateTime.now().difference(DateTime.parse(widget.model!.requestDate!));
  return  Padding(
      padding: const EdgeInsets.all(8.0),
      child:Material(
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
    child: CustomText(text:widget.model!.type!,color: Colors.white,),),
        Padding(
      padding: const EdgeInsets.only(left: 8.0),
      child: CustomText(text:    timeago.format(DateTime.now().subtract(difference), locale: 'ar'),fontSize: 12,),
    )
      ],
    ),
        columnData(context),
          widget.model!.bookingStatus=="ACCEPTED"?
      Align(alignment: Alignment.bottomLeft,child:

      Container(
        padding:const EdgeInsets.all(5.0) ,
        width: 100,
        decoration: BoxDecoration(
            color: primaryColor,
            borderRadius:
            BorderRadius.circular(
                5)) ,
        alignment:Alignment.topLeft,
        child: CustomText(
            text:"رقم الدور : "+widget.model!.number!.toString(),
        color: Colors.white,
      )),
  ):Container(),
      ],
    )
    )
    );
  }

  Widget columnData(BuildContext context){

  return Padding(
    padding: const EdgeInsets.all(8.0),
    child: Column(
    mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center
    ,children: [

      CustomText(text:widget.model!.patientName!,color: primaryColor,fontSize: 18,fontWeight: FontWeight.bold,alignment: Alignment.center,),
      CustomText(text:widget.model!.painSummary!,color: primaryColor,alignment: Alignment.center,),
      widget.model!.bookingStatus=="ACCEPTED"?  CustomText(text:"تاريخ القدوم: "+widget.model!.date!,color: primaryColor,):Container(),
      SizedBox(height: 20),
    widget.model!.bookingStatus=="WAITING"?Row(
    mainAxisAlignment: MainAxisAlignment.center,
      children:[ Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
    width: MediaQuery.of(context).size.width*.35,
        color: [
        Color(0xFF1E88E5),
        Color(0xFF0D47A1),
        ],
        text: "قبول",
        onPress:()=>showDialogReasonDialog(context,"accpt"),
        textColor: Colors.white),
      ),Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomButton(
    width: MediaQuery.of(context).size.width*.35,

    color: [
    Color(0xFF1E88E5),
    Color(0xFF0D47A1),
    ],
    text: "رفض",
    onPress: ()=>showDialogReasonDialog(context,"refuse"),
    textColor: Colors.white),
      )],
    ):Container(),
      ]),
  );

  }

  showDialogReasonDialog(BuildContext context,String type) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _reasonController = TextEditingController();
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
              title: Text(type=="refuse"?"السبب ؟":"الموافقة علي الطلب"),
              content: Form(
                key: _formKey,
                child: Column(
                  children: [
                    type=="refuse"?Container():TextFormField(
                      onTap: ()=>_showDatePacker(_dateController,context),
                      readOnly: true,
                      controller: _dateController,
                      validator: (String? value) {
                    if (value!.isEmpty&&type!="refuse")
                    return "يجب ان تدخل تاريخ الحجز";
                    },
                      decoration: InputDecoration(
                          labelText: "الموعد الذي سوف ياتي به المريض",
                          labelStyle: TextStyle(fontSize: 12)),
                    ),
                    TextFormField(
                      controller: _reasonController,
                      validator: (String? value) {
                    if (value!.isEmpty)
                    return "يجب ان تدخل سبب رفض هذا الحجز";
                    },
                      decoration: InputDecoration(
                          labelText: type=="refuse"?"السبب ؟":"تعليمات للمريض عند الحضور",
                          labelStyle: TextStyle(fontSize: 12)),
                    ),
                  ],
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


                      if (type == "refuse") {
                      if (!await bookingProvider
                          .refuseBooking(bookingId: widget.model!.bookingId,token: widget.token,note: _reasonController.text))
                      Fluttertoast.showToast(msg: bookingProvider.error!);
                      else {
                      Fluttertoast.showToast(msg: "تم  رفض الحجز بنجاح");
                      Navigator.pop(context);
                      }
                      }
                      else {
                      if (!await bookingProvider
                          .acceptBooking(bookingId: widget.model!.bookingId,token: widget.token,note: _reasonController.text,date: _dateController.text))
                      Fluttertoast.showToast(msg: bookingProvider.error!);
                      else {
                      Fluttertoast.showToast(msg: "تم الموافقة علي الحجز بنجاح");
                      bookingProvider.setSecondCardIndex(bookingProvider.firstBookingIndex=="noOne"?"1":"0");
                      Navigator.pop(context);
                      }
                      }
                      Provider.of<UserProvider>(context,listen: false).refresh();

                      }
                      } on SocketException catch (_) {
                      Fluttertoast.showToast(
                      msg: "تأكد من إتصالك بالإنترنت",
                      toastLength: Toast.LENGTH_LONG);
                      }
                      }
                    },
                    child: Text("إرسال",
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

  _showDatePacker(TextEditingController dateController,BuildContext context) async{

    final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime(2050,1,1));

    if (picked != null) {
    setState((){
    dateController.text=picked.year.toString()+ "-"+ picked.month.toString()+"-"+picked.day.toString();
    });
    }
  }

}
