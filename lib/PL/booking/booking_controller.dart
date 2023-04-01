
import 'package:clinic_admin/PL/utilities/drawer.dart';
import 'package:clinic_admin/constants.dart';
import 'package:flutter/material.dart';
import 'Booking_filter.dart';

class BookingController extends StatefulWidget {

  @override
  _BookingControllerState createState() => _BookingControllerState();
}

class _BookingControllerState extends State<BookingController> {
  int currentIndex = 0;
  List<String> choices = ["الكل", "إختر تاريخ"];
  final _key=GlobalKey<ScaffoldState>();

  DateTime initailDate=DateTime.now();
  String selectedItem = "الكل";  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        onWillPop: ()async{
          if(_key.currentState!.isDrawerOpen)
            Navigator.pop(context);
          else
            onBack(context);
          return false;
        },
      child:  Scaffold(
        key:_key,
        appBar: _appBar(),
        body:Stack(children: <Widget>[
         backgroundImage()!, loadingBody()!

    ]),
        bottomNavigationBar: bottomNavigationBar(),
      drawer: CustomDrawer(),
      )
    );
  }

  Widget? loadingBody() {
    switch (currentIndex) {
     // case 0:
       // return HomePage();
      case 0:
        return BookingFilter(type:0 ,date: selectedItem,);
      case 1:
        return BookingFilter(type:1 ,date: selectedItem,);
      case 2:
        return BookingFilter(type:2 ,date: selectedItem,);
      case 3:
        return BookingFilter(type:3 ,date: selectedItem,);
    }
  }

  AppBar? _appBar() {
    switch (currentIndex) {
      case 0:
        return dateAppbar("قائمة الإنتظار");
      case 1:
        return dateAppbar("الحجوزات الموافق عليها");
      case 2:
        return dateAppbar("تم الإنتهاء");
      case 3:
        return dateAppbar("الحجوزات المرفوضة");

    }
  }

  Widget bottomNavigationBar() {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: BottomNavigationBar(
      items: [

        BottomNavigationBarItem(
            label: 'الانتظار',
            icon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Icon(Icons.more_horiz))),
        BottomNavigationBarItem(
            label: 'الموافق عليه',
            icon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Icon(Icons.check))),
        BottomNavigationBarItem(
            label: 'تم الانتهاء',
            icon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Icon(Icons.assignment_turned_in,))),
        BottomNavigationBarItem(
            label: 'المرفوض',
            icon: Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Icon(Icons.cancel_sharp,))),
      ],
      currentIndex: currentIndex,
      onTap: (index) {
        setState(() {
          currentIndex = index;
        });
      },
      elevation: 20,
      selectedItemColor: primaryColor,
      unselectedItemColor: Colors.black45,
unselectedLabelStyle: TextStyle(color: Colors.black45,fontSize: 9),
      showUnselectedLabels: true,
    ));
  }


  AppBar dateAppbar(String title){
   return  AppBar(
     automaticallyImplyLeading: false,
       flexibleSpace: Container(child: backgroundImage()!,),backgroundColor: Colors.grey[300],
      centerTitle: false,
      leading:
      Container(margin: const EdgeInsets.all(5.0),
        decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor)),

        child: IconButton(icon:Icon(Icons.menu,color: primaryColor,size: 20,),onPressed: ()=>_key.currentState!.openDrawer(),
      )),
       title: Text(
        title,
        style: TextStyle(color: primaryColor, fontSize:16,fontWeight: FontWeight.bold),
      ), actions: [

    PopupMenuButton(
    icon: Icon(Icons.arrow_drop_down,color:primaryColor,),
    elevation: 3.2,
    tooltip: 'فرز بواسطة',
    onSelected: (String choice) {
    if(choice=="الكل")
    setState(()=>
    selectedItem = choice);
    else
    _showDatePacker();

    },
    itemBuilder: (BuildContext context) {
    return choices.map((String choice) {
    return PopupMenuItem(
    value: choice,
    child: Text(
    choice,
    style: TextStyle(fontSize: 12),
    ),
    );
    }).toList();
    }),Center(
    child: Text("${selectedItem}",
    style: TextStyle(color: primaryColor, fontSize: 12))),
    Container(margin: const EdgeInsets.all(5.0),
    decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor)),
    child: IconButton(icon:Icon(Icons.arrow_forward,color: primaryColor,size: 20,),onPressed:  ()=>onBack(context))),
    ],);


  }

   _showDatePacker() async{

     final DateTime? picked = await showDatePicker(
     context: context,
     initialDate: initailDate,
     firstDate: DateTime(2021,1,1),
     lastDate: DateTime(2050,1,1));

     if (picked != null) {
       setState((){
     selectedItem =
     picked.year.toString()+ "-"+ picked.month.toString()+"-"+picked.day.toString();
     initailDate=picked;
     });
   }
}
}
