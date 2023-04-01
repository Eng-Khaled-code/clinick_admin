
import 'package:clinic_admin/PL/profile/specializationWidget_widget.dart';
import 'package:clinic_admin/PL/profile/top_container.dart';
import 'package:clinic_admin/PL/profile/work_days/work_days_widget.dart';
import 'package:clinic_admin/PL/utilities/drawer.dart';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:provider/provider.dart';
import 'package:clinic_admin/PL/profile/profile_card_item.dart';
class ProfilePage extends StatefulWidget {

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final _key=GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context);
    return WillPopScope(
      onWillPop: ()async{
        if(_key.currentState!.isDrawerOpen)
          Navigator.pop(context);
        else
        onBack(context);
        return false;
        },
      child: Directionality(

      textDirection: TextDirection.rtl,
        child: Scaffold(
          key: _key,
          drawer: CustomDrawer(),
          appBar: AppBar(
              flexibleSpace: Container(child: backgroundImage()!,),backgroundColor: Colors.grey[300],
            title: Text(
              "تحديث البيانات الشخصية",
              style: TextStyle(color:primaryColor,fontSize: 15),
            ),
            leading:Container(margin: const EdgeInsets.all(5.0),
              decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor)),

              child: IconButton(icon:Icon(Icons.menu,color: primaryColor,size: 20,),onPressed:()=>_key.currentState!.openDrawer()
            )) ,
            actions: [
              Container(margin: const EdgeInsets.all(5.0),
                  decoration: BoxDecoration(shape: BoxShape.circle,border: Border.all(color:primaryColor)),
                  child: IconButton(icon:Icon(Icons.arrow_forward,color: primaryColor,size: 20,)
                      ,onPressed:  ()=>onBack(context))) ,
            ],
          ),
          body:Stack(
            alignment: Alignment.center,
            children: <Widget>[
            backgroundImage()!,RefreshIndicator(
             onRefresh: ()async{
               await user.loadUserData(doctorId: user.userInformation!.doctorId,token: user.userInformation!.token);

             },
              child: SingleChildScrollView(
                  child:user.isLoading?Center(child: loadingWidget()!) :
                  Column(
                    children: <Widget>[
                      TopContainer(userModel: user.userInformation
                          ),
                      SizedBox(height: 4.0),
                      Text(
                        user.userInformation!.userName!,
                        style: TextStyle(
                          fontSize: 14,
                        ),
                      ),
                      Text(
                        user.userInformation!.doctorName!,
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                            children: [
                            Text("التقييم : "),
                        Text("5/"),

                        Text(user.userInformation!.ratingValue!,style: TextStyle(color: primaryColor,fontSize: 30,fontWeight: FontWeight.bold),),
                      SizedBox(width: 15,),
                      RatingBar.builder(initialRating: double.parse(user.userInformation!.ratingValue!),
                        ignoreGestures: true,
                        itemSize: 25,
                        direction: Axis.horizontal,allowHalfRating: true
                        ,itemCount: 5,itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context,_)=>Icon(Icons.star,color: Colors.amber,),onRatingUpdate: (rating){},)
                    ],
                  ),
        ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Row(
                          children: [
                            Text("الاشخاص المعجبون : "),
                            SizedBox(width: 15,),
                            Icon(Icons.favorite,color: Colors.pink,),
                            Text(user.userInformation!.likeCounter!.split(".").length>0?user.userInformation!.likeCounter!.split(".")[0]:user.userInformation!.likeCounter!,style: TextStyle(color: primaryColor,fontSize: 24,fontWeight: FontWeight.bold),),
                               ],
                        ),
                      ),
                      SizedBox(height: 20,)
                      ,WorkDays(workDaysList: user.userInformation!.workDays,token: user.userInformation!.token,doctorId: user.userInformation!.doctorId,),
                      SizedBox(height: 20,)
                     ,SpecializationWidget(specializations: user.userInformation!.specializations),
                      ListView(
                        physics: NeverScrollableScrollPhysics(),
                        children: [
                          CardItem(title:"الاسم", data:user.userInformation!.doctorName,doctorId:  user.userInformation!.doctorId,token:user.userInformation!.token! ),
                          CardItem(title:"رقم الهاتف 1", data:user.userInformation!.doctorPhone,doctorId: user.userInformation!.doctorId,token:user.userInformation!.token! ),
                          CardItem(title:"رقم الهاتف 2", data:user.userInformation!.assistantPhone,doctorId:  user.userInformation!.doctorId,token:user.userInformation!.token! ),
                          CardItem(title:"عدد المرضي في اليوم الواحد", data:user.userInformation!.maxPatient,doctorId:  user.userInformation!.doctorId,token:user.userInformation!.token! ),
                          CardItem(title:"العنوان", data:user.userInformation!.address,doctorId: user.userInformation!.doctorId,token:user.userInformation!.token! ),
                          CardItem(title:"نبذه عن الدكتور", data:user.userInformation!.aboutDoctor,doctorId: user.userInformation!.doctorId,token:user.userInformation!.token! ),
                        ],
                        shrinkWrap: true,
                      )
                    ],
                  ),
                ),
            ),
            ]),
        ),
      ),
    );
  }
}
