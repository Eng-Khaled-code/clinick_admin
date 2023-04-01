import 'package:clinic_admin/PL/utilities/custom_text.dart';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/model/notify_model.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:uni_links/uni_links.dart';
import 'package:url_launcher/url_launcher.dart';

import 'book_details.dart';

class NotifyCard extends StatelessWidget {
  NotifyModel? model;
  Color? seenColor;
  NotifyCard({this.model,this.seenColor});
  SharedPreferences? prefs;

/*
  Future<void> initUniLinks(BuildContext context,String token)async{

    try {

        getInitialUri().then((Uri ? initialLink){

        if(initialLink != null)
        {
        List<String> splitted = initialLink.path.toString().split('/');
        print(splitted[splitted.length - 1]);
        if (splitted[splitted.length - 1] == 'bookings.php')
        {
        goTo(context: context,
        to: BookDetailsPage(bookingId:initialLink.queryParameters["id"]??"no",
        token:token,));

        }


        }    });}

    on PlatformException {
      print('platfrom exception unilink');
    }

  }*/

  @override
  Widget build(BuildContext context) {

    UserProvider userProvider=Provider.of<UserProvider>(context);

    final difference = DateTime.now().difference(DateTime.parse(model!.sendTime!));
    return  InkWell(
      onTap:()async{

     /*   if(model!.notiData!["type"]=="booking") {
          goTo(context: context,
              to: BookDetailsPage(bookingId:model!.notiData!["id"],
                token: userProvider.userInformation!.token,));
        } else*/


          List<String> splitted =Uri.parse( model!.redirectionLink!).path.toString().split('/');
          if (splitted[splitted.length - 1] == 'bookings.php')
          {
            goTo(context: context,
                to: BookDetailsPage(bookingId:Uri.parse( model!.redirectionLink!).queryParameters["id"]??"no",
                  token:userProvider.userInformation!.token,));
          }
          else
            await launch(model!.redirectionLink!);

          prefs=await SharedPreferences.getInstance();

          prefs!.setString(model!.messageId!, "1") ;
        userProvider.refresh();
        //await initUniLinks(context,userProvider.userInformation!.token!);


      } ,
      child: Container(
        color: seenColor,

        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment:CrossAxisAlignment.start,
                children: [
                  CircleAvatar(backgroundImage:NetworkImage("https://mumbaimirror.indiatimes.com/thumb/77794986.cms?resizemode=4&width=400")),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                    Text(model!.title!,maxLines: 1,overflow: TextOverflow.ellipsis,style:TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 13),),
                        CustomText(text:  "  "+timeago.format(DateTime.now().subtract(difference), locale: 'ar'),fontSize: 12,alignment: Alignment.centerRight,color: Colors.grey,),
                       /* model!.notiData!["type"]=="booking"?CustomText(text:model!.notiData!["booking_type"],fontSize: 12,alignment: Alignment.centerRight,color: Colors.green,)
                         :
                        CustomText(text:model!.notiData!["link_name"],fontSize: 12,alignment: Alignment.centerRight,color: Colors.green,),
*/
                      ],
                    ),
                  )
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Text(model!.body!,style:TextStyle(color: Colors.grey,)),
            ),
Divider()
      ],
      )
      ),
    );
  }
}
