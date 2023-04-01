import 'package:clinic_admin/PL/home/custom_status.dart';
import 'package:clinic_admin/PL/notification/book_details.dart';
import 'package:clinic_admin/PL/utilities/custom_notify.dart';
import 'package:clinic_admin/PL/utilities/custom_text.dart';
import 'package:clinic_admin/PL/home/top_booking_card.dart';
import 'package:clinic_admin/PL/utilities/custom_alert_dialog.dart';
import 'package:clinic_admin/PL/utilities/drawer.dart';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/model/booking_model.dart';
import 'package:clinic_admin/provider/booking_provider.dart';
import 'package:clinic_admin/provider/drawer_provider.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:clinic_admin/services/main_operations.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';
import 'bottom_booking_card.dart';

bool linkOpend= false;

class HomePage extends StatefulWidget {
  static String? placeStatus;
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {

 final _key=GlobalKey<ScaffoldState>();

leaveApp(BuildContext context)async{
  showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
        title: "تنبيه",
        onPress: () async {
          SystemNavigator.pop();
        },
        text: "هل تريد الخروج من التطبيق بالفعل",
      ));
  return true;
}
 String url="https://ahmedmhassaan.000webhostapp.com/DoctorsDashboard/api/v1/includes/Bookings/allBookings.php";



 Future<Null> initUniLinks(BuildContext context,String token)async{
   try {
     if (linkOpend==false) {

     getInitialUri().then((Uri ? initialLink){

       if(initialLink != null)
       {
         linkOpend=true;

       List<String> splitted = initialLink.path.toString().split('/');
       print(splitted[splitted.length - 1]);
       if (splitted[splitted.length - 1] == 'bookings.php')
       {
       goTo(context: context,
       to: BookDetailsPage(bookingId:initialLink.queryParameters["id"]??"no",
       token:token,));

       }
       }


       });}
     }
     on PlatformException {
       print('platfrom exception unilink');
     }

 }
 @override
  Widget build(BuildContext context) {

    UserProvider userProvider=Provider.of<UserProvider>(context);

    Map<String, String> acceptPostData = {"token":userProvider.userInformation!.token!,"docId":userProvider.userInformation!.doctorId!,"status":"ACCEPTED","date": 'now'};
    Map<String, String> waitPostData = {"token":userProvider.userInformation!.token!,"docId":userProvider.userInformation!.doctorId!,"status":"WAITING","date": ''};
    Map<String, String> refusePostData = {"token":userProvider.userInformation!.token!,"docId":userProvider.userInformation!.doctorId!,"status":"REFUSED","date": 'now'};
    Map<String, String> finishPostData = {"token":userProvider.userInformation!.token!,"docId":userProvider.userInformation!.doctorId!,"status":"FINISHED","date": 'now'};
    initUniLinks(context,userProvider.userInformation!.token!);

    return WillPopScope(
        onWillPop: ()async{
          if(_key.currentState!.isDrawerOpen)
            Navigator.pop(context);
          else
           await leaveApp(context);
          return false;
        },
        child:Directionality(textDirection: TextDirection.rtl,
            child:Scaffold(
              key: _key,
              backgroundColor: Colors.grey[300],
              appBar:_appbar(context),
              drawer: CustomDrawer(),
              body: RefreshIndicator(onRefresh: ()async{
                userProvider.refresh();
              },
               child:  body(context,acceptPostData,refusePostData,waitPostData,finishPostData,userProvider.userInformation!.token,userProvider.userInformation!.placeStatus!))
              ,floatingActionButton: FloatingActionButton.extended(
                onPressed: ()=>showAddDialog(context,userProvider.userInformation!.doctorId!,userProvider.userInformation!.token!)
                , label:Text("إضافة حجز") ),)));
}

AppBar _appbar(BuildContext context){
  return AppBar(
centerTitle: false,
    leading: Container(margin: const EdgeInsets.all(5.0),
  decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor),color: Colors.white,),

      child: IconButton(icon:Icon(Icons.menu,color: primaryColor,size: 20,),onPressed:
          ()=>_key.currentState!.openDrawer()
    )),
    backgroundColor:Colors.grey[300] ,
    title: CustomText(text:"الرئيسية",fontWeight: FontWeight.bold,fontSize: 18,)
  ,actions: [
  Container(margin: const EdgeInsets.all(5.0),
  decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor),color: Colors.white,),
  child: CustomNotifyWidget(
  page: 'home',
  icon: Icons.notifications_none,
  onPress: () async {

    Provider.of<DrawerProvider>(context,listen: false).setPage("noti");

    //  prefs = await SharedPreferences.getInstance();
 // prefs!.setString("last_date", DateTime.now().toString());
 // await notifyProvider.loadNotifyCount();

  },
  count: 0),),
    Container(
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
                 onPressed:  ()async=>await leaveApp(context) ,)),

  ],);
}

Widget body(BuildContext context,Map<String,String> acceptPostData,Map<String,String> refusePostData,Map<String,String> waitPostData,Map<String,String> finishPostData,token,String placeStatus){
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child:SingleChildScrollView(child:
      Column(

children: [
      RichText(
      textAlign: TextAlign.center,
      text: TextSpan(

        children: <TextSpan>[
          TextSpan(
              text:placeStatus=="0"
                  ?
              "هذه العيادة مغلقة حاليا ولا يمكنها استقبال الحجوزات لفتحها لإستقبال الحجوزات إضغط ":"العيادة يمكنها استقبال طلبات الان لغلقها إضغط ",
              style: TextStyle(color: Colors.black)),
          TextSpan(
              text: "هنا",
              style:TextStyle(fontWeight: FontWeight.bold,fontSize: 18.0,color:placeStatus=="0"?primaryColor:Colors.red,decoration: TextDecoration.underline),
              recognizer: TapGestureRecognizer()
                ..onTap = () {
                  showPlaceStatusDialog(context,acceptPostData["docId"]!,token, placeStatus)  ;               }),
        ],
      ),
      ),
  nextBookingWidget(context,acceptPostData,token),
         Column(
  children: [

Padding(
padding: const EdgeInsets.all(15.0),
        child: CustomText(text: "قائمة الإنتظار",fontWeight: FontWeight.bold,color: Colors.black,alignment: Alignment.topRight,),
      ),
        Padding(
            padding: const EdgeInsets.only(right: 15.0),
            child: Container(
                width: double.infinity,
                height:MediaQuery.of(context).orientation==Orientation.portrait? MediaQuery.of(context).size.height*.4:MediaQuery.of(context).size.height*.7,
                padding:const EdgeInsets.all( 8.0) ,
                decoration: BoxDecoration(color: Colors.white,
                    borderRadius: BorderRadius.only(topRight: Radius.circular(10),
                        bottomRight: Radius.circular(10))),
                child: FutureBuilder<List>(
                    future: MainOperation().loadList(waitPostData,url),
                    builder:(context,snapshot)=>!snapshot.hasData?loadingWidget()!:
                snapshot.data!.length==0?noDataCard("لا توجد حجوزات في الانتظاز اليوم","noData"):snapshot.data!.first["code"]==0?noDataCard("تأكد من إتصال الإنترنت وإذا كنت متصل بالفعل اعد فتح التطبيق إذا ظل هذا الخطا موجود قم بالتواصل معنا","error"):
            ListView.builder(scrollDirection: Axis.horizontal,itemCount:  snapshot.data!.length,
            itemBuilder:(context,position)=> BottomBookingCard(token: token,model:BookingModel.fromSnapshot(snapshot.data![position])))
    ))),



  Padding(
  padding: const EdgeInsets.all(15.0),
  child: CustomText(text: "تم الإلغاء",fontWeight: FontWeight.bold,color: Colors.black,alignment: Alignment.topRight,),
  ),
  Padding(
  padding: const EdgeInsets.only(right: 15.0),
  child: Container(width: double.infinity,
  padding:const EdgeInsets.all( 8.0) ,

  height: MediaQuery.of(context).orientation==Orientation.portrait?MediaQuery.of(context).size.height*.35:MediaQuery.of(context).size.height*.6,
  decoration: BoxDecoration(color: Colors.white,
  borderRadius: BorderRadius.only(topRight: Radius.circular(10),
  bottomRight: Radius.circular(10))),
  child: FutureBuilder<List>(
      future: MainOperation().loadList(refusePostData,url),
      builder:(context,snapshot)=>!snapshot.hasData?loadingWidget()!:
  snapshot.data!.length==0?noDataCard("لا توجد حجوزات مرفوضة اليوم","nodata"):snapshot.data!.first["code"]==0?noDataCard("تأكد من إتصال الإنترنت وإذا كنت متصل بالفعل اعد فتح التطبيق إذا ظل هذا الخطا موجود قم بالتواصل معنا","error"):
      ListView.builder(scrollDirection: Axis.horizontal,itemCount: snapshot.data!.length,itemBuilder:(context,position){
      return BottomBookingCard(model:BookingModel.fromSnapshot(
    snapshot.data![position]));}),
  )
  )),



          Padding(
            padding: const EdgeInsets.all(15.0),
            child: CustomText(text: "تم الكشف",fontWeight: FontWeight.bold,color: Colors.black,alignment: Alignment.topRight,),
          ),
          Padding(
              padding: const EdgeInsets.only(right: 15.0),
              child: Container(width: double.infinity,
                  padding:const EdgeInsets.all( 8.0) ,

                  height:MediaQuery.of(context).orientation==Orientation.portrait? MediaQuery.of(context).size.height*.3:MediaQuery.of(context).size.height*.5,
                  decoration: BoxDecoration(color: Colors.white,
                      borderRadius: BorderRadius.only(topRight: Radius.circular(10),
                          bottomRight: Radius.circular(10))),
                  child:FutureBuilder<List>(
  future: MainOperation().loadList(finishPostData,url),
  builder:(context,snapshot)=>!snapshot.hasData?loadingWidget()!:
  snapshot.data!.length==0?noDataCard("لا توجد حجوزات اليوم","noData"):snapshot.data!.first["code"]==0?noDataCard("تأكد من إتصال الإنترنت وإذا كنت متصل بالفعل اعد فتح التطبيق إذا ظل هذا الخطا موجود قم بالتواصل معنا","error"):
  ListView.builder(scrollDirection: Axis.horizontal,itemCount:snapshot.data!.length,itemBuilder:(context,position)
    => BottomBookingCard(model:BookingModel.fromSnapshot(
                      snapshot.data![position]),))
              ))),

  ],
)

],    )),
    );
}

Widget nextBookingWidget(BuildContext context,Map<String,String >acceptPostData,token){
  BookingProvider bookingProvider=Provider.of<BookingProvider>(context);

  return FutureBuilder<List>(
      future: MainOperation().loadList(acceptPostData,url),
      builder:(context,snapshot){
        return !snapshot.hasData
          ?Padding(
            padding: const EdgeInsets.all(8.0),
            child: loadingWidget()!,
          ):
        snapshot.data!.length==0
    ?
        noDataCard("لا توجد حجوزات اليوم","noData")
      :
  snapshot.data!.first["code"]==0
  ?
  noDataCard("تأكد من إتصال الإنترنت وإذا كنت متصل بالفعل اعد فتح التطبيق إذا ظل هذا الخطا موجود قم بالتواصل معنا","error")
      :

  Column(
  children:[
        bookingProvider.firstBookingIndex=="noOne"?
  noDataCard("لا يوجد احد بداخل حجرةالكشف","noData"):
  TopBookingCard(token:token,listLength:snapshot.data!.length ,index:int.parse(bookingProvider.firstBookingIndex),number: 1,
        model: BookingModel.fromSnapshot(snapshot.data![int.parse(bookingProvider.firstBookingIndex)]),),
        snapshot.data!.length<1?Container()
            :
        bookingProvider.secondBookingIndex=="noOneRemain"
        ||int.parse(bookingProvider.secondBookingIndex)>= snapshot.data!.length?Container()
       :
        TopBookingCard(
        token: token,listLength: snapshot.data!.length,
        index:int.parse(bookingProvider.secondBookingIndex),
        number: 2,
        model: BookingModel.fromSnapshot(snapshot.data![int.parse(bookingProvider.secondBookingIndex)]),)
      ,

   Padding(
  padding: const EdgeInsets.all(15.0),
  child: CustomText(text: "الحجوزات التالية",fontWeight: FontWeight.bold,color: Colors.black,alignment: Alignment.topRight,),
  ),

  Padding(
  padding:const EdgeInsets.only(right: 15.0 ),
  child: Container(width: double.infinity,
  padding:const EdgeInsets.all( 8.0) ,

  height:MediaQuery.of(context).orientation==Orientation.portrait? MediaQuery.of(context).size.height*.27:MediaQuery.of(context).size.height*.55,
  decoration: BoxDecoration(color: Colors.white,
  borderRadius: BorderRadius.only(topRight: Radius.circular(10),
  bottomRight: Radius.circular(10))),
  child:
  ListView.builder(scrollDirection: Axis.horizontal,itemCount:snapshot.data!.length,itemBuilder:(context,position)
  => BottomBookingCard(model:BookingModel.fromSnapshot(snapshot.data![position])))

  ))]);}
    );
}

  noDataCard(String message,type){
    return Container(
      padding: const EdgeInsets.all(10),
      margin: const EdgeInsets.all(10),
      decoration: BoxDecoration(        color:Colors.white,
          border: Border.all(color:primaryColor),borderRadius: BorderRadius.circular(10)),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center, children: [
        Icon(Icons.assignment,size: 50,color: primaryColor),
        SizedBox(height: 15.0),
        CustomText(text: message,maxLine: 2,)]
      ,),
    );
  }


 showAddDialog(BuildContext context,String docId,String token) {
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
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10)),
             title: Text("إضافة حجز جديد بتاريخ اليوم"),
             content: Form(
               key: _formKey,
               child: TextFormField(
                 controller: _controller,
                 validator: (String? value) {
               if (value!.isEmpty)
               return "يجب ان تدخل الاسم";
               },
                 decoration: InputDecoration(
                     labelText: "اسم المريض",
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
                     if (!await bookingProvider
                         .addBooking(doctorId: docId,token: token,name: _controller.text)){
                     Fluttertoast.showToast(msg: bookingProvider.error!);
                     print(bookingProvider.error!);
                     }
                     else {
                     Fluttertoast.showToast(msg: "تم  إضافة الحجز بنجاح");
                     Navigator.pop(context);
                     }
                     }
                   },
                   child: Text("إضافة",
                       style:
                       TextStyle(fontSize: 13))),
               TextButton(
                   onPressed: () {
                     Navigator.pop(context);
                   },
                   child: Text("إلغاء", style: TextStyle(fontSize: 13, color: Colors.red))),
             ],
           ),
         );
       });

 }


 showPlaceStatusDialog(BuildContext context,String docId,String token,String placeStatus) {
   HomePage.placeStatus=placeStatus;
   final _formKey = GlobalKey<FormState>();
   TextEditingController _controller = TextEditingController();

   showDialog(
       barrierDismissible: false,
       context: context,
       builder: (context) {
        UserProvider userProvider=Provider.of<UserProvider>(context);
        return Directionality(
           textDirection: TextDirection.rtl,

           child: AlertDialog(
             scrollable: true,
             shape: RoundedRectangleBorder(
                 borderRadius: BorderRadius.circular(10)),
             title: Text("تغيير حالة العيادة"),
             content: Form(
             key: _formKey,
             child:  Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children: [CustomPlaceStatus(userProvider),
                 HomePage.placeStatus=="1"?Container():Padding(
                   padding:  EdgeInsets.only(right:20.0),
                   child: TextFormField(
           controller: _controller,
           validator: (String? value) {
         if (value!.isEmpty&&HomePage.placeStatus=="0")
         return "يجب ان تدخل السبب";
         },
           decoration: InputDecoration(
               labelText: "سبب الإغلاق",
               labelStyle: TextStyle(fontSize: 13)),
         ),
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

                     if (_formKey.currentState!.validate()) {
                     if (!await userProvider
                         .updatePlaceStatus(status:HomePage.placeStatus, reason: _controller.text))
                     Fluttertoast.showToast(msg: userProvider.error!);
                     else {
                     Fluttertoast.showToast(msg: "تم الحفظ بنجاح");
                     Navigator.pop(context);
                     await userProvider.loadUserData(doctorId: docId,token: token);

                     }
                     }
                   },
                   child: Text("حفظ",
                       style:
                       TextStyle(fontSize: 13))),
               TextButton(
                   onPressed: () {
                     Navigator.pop(context);
                   },
                   child: Text("إلغاء", style: TextStyle(fontSize: 13, color: Colors.red))),
             ],
           ),
         );
       });

 }

}