
import 'package:clinic_admin/PL/booking/booking_card.dart';
import 'package:clinic_admin/PL/utilities/custom_text.dart';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/model/booking_model.dart';
import 'package:clinic_admin/services/main_operations.dart';
import 'package:flutter/material.dart';

class BookDetailsPage extends StatelessWidget {
  final String? bookingId;
  final String? token;
  BookDetailsPage({this.bookingId,this.token});


  @override
  Widget build(BuildContext context) {

    Map<String,String> postData={
      "token":token!  ,"id":bookingId!,
        };

    String url="https://ahmedmhassaan.000webhostapp.com/DoctorsDashboard/api/v1/includes/Bookings/getBooking.php";

    return Directionality(textDirection: TextDirection.rtl,
    child:  Scaffold(
        backgroundColor:Colors.grey[300] ,
      appBar: AppBar(
        backgroundColor:Colors.grey[300] ,
        automaticallyImplyLeading: false,
        title: Text("التفاصيل",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold)),actions: [Container(
          margin: const EdgeInsets.all(5.0),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(color:primaryColor)
            ,color: Colors.white,),
          child: IconButton(
            icon:Icon(
              Icons.arrow_forward,
              color: primaryColor,
              size: 20,),
            onPressed:  ()=>Navigator.pop(context)))],),
      body:
      token==''||token==null||bookingId==''||bookingId==null
          ?
      loadingWidget()
          :
      FutureBuilder<Map<String,dynamic>>(
          future:MainOperation().getOperation(postData,url)
          ,builder:(context,snapshot)
      {
        return !snapshot.hasData||snapshot.connectionState==ConnectionState.waiting?
      loadingWidget():
      snapshot.data!["code"]==0
      ?
          errorCard("حدث خطا إنتظر لحظة او اعد فتح هذه الصفحة مجددا")
            :

        Column(
          children: [
            snapshot.data!["response"].toString()=="[]"||bookingId=="no"
                ?
            errorCard("لا توجد نتائج ربما قام صاحب الحجز بحذفه")
                : BookingCard(token: postData["token"],model: BookingModel.fromSnapshot(snapshot.data!["response"][0]),),
          ],
        );}
      ),

      ),
    );
  }

    errorCard(String message){
    return Container(
    padding: const EdgeInsets.all(10),
    margin: const EdgeInsets.all(10),
    decoration: BoxDecoration(        color:Colors.white,
    border: Border.all(color:primaryColor),borderRadius: BorderRadius.circular(10)),
    child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center, children: [
    Icon(Icons.error,size: 50,color: primaryColor),
    SizedBox(height: 15.0),
    CustomText(text:message,maxLine: 2,)]
    ,),
    );
    }
}
