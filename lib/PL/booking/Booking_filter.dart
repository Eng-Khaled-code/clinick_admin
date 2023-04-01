import 'package:clinic_admin/PL/utilities/custom_text.dart';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/model/booking_model.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:clinic_admin/services/main_operations.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'booking_card.dart';

class BookingFilter extends StatelessWidget {
  final int? type;
  final String? date;

  String url="https://ahmedmhassaan.000webhostapp.com/DoctorsDashboard/api/v1/includes/Bookings/allBookings.php";
  BookingFilter({this.type, this.date});

  @override
  Widget build(BuildContext context) {
    UserProvider user=Provider.of<UserProvider>(context);
    String bookingStatus=type==0?"WAITING":type==1?"ACCEPTED":type==2?"FINISHED":type==3?"REFUSED":"";
    String? dateFilter=date =="الكل"?'':date!;
    Map<String, String> postData = {"token":user.userInformation!.token!,"docId":user.userInformation!.doctorId!,"status":bookingStatus,"date": dateFilter};


    return RefreshIndicator(
    onRefresh: ()async{
      user.refresh();
    },
    child:FutureBuilder<List>(
      future: MainOperation().loadList(postData,url),
      builder:(context,snapshot){

        return  Container(
        child :
        !snapshot.hasData||snapshot.connectionState==ConnectionState.waiting
        ?
        loadingWidget()!
            :
    snapshot.data!.length==0?noDataCard("لا توجد حجوزات حتي الان"):snapshot.data!.first["code"]==0?noDataCard("تأكد من إتصال الإنترنت وإذا كنت متصل بالفعل اعد فتح التطبيق إذا ظل هذا الخطا موجود قم بالتواصل معنا"):
    ListView.builder(

    itemCount:snapshot.data!.length ,itemBuilder: (context,position){
    print(snapshot.data!.toString());

          return BookingCard(model: BookingModel.fromSnapshot(snapshot.data![position]),token: postData["token"]);

      }),);
        }
    ));
  }

  noDataCard(String message){
    return ListView(
      children:[ Container(
        padding: const EdgeInsets.all(10),
        height: 300,
        margin: const EdgeInsets.all(10),
        decoration: BoxDecoration(border: Border.all(color:primaryColor),borderRadius: BorderRadius.circular(10)),
        child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.assignment,size: 50,color: primaryColor),
          SizedBox(height: 15.0),
          CustomText(text: message)]
          ,),
      )]
    );
  }
}
