
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/provider/booking_provider.dart';
import 'package:clinic_admin/provider/drawer_provider.dart';
import 'package:clinic_admin/provider/notify_provider.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:clinic_admin/start_point/screen_controller.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:firebase_crashlytics/firebase_crashlytics.dart';


const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'high_importance_channel', // id
    'High Importance Notifications', // title
    'This channel is used for important notifications.', // description
    importance: Importance.high,
    playSound: true);

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('A bg message just showed up :  ${message.messageId}');
}



Future<void> main()  async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
 // FirebaseCrashlytics.instance.crash();

  timeago.setLocaleMessages('ar', timeago.ArMessages());

  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  await flutterLocalNotificationsPlugin
     .resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  await FirebaseMessaging.instance.setForegroundNotificationPresentationOptions(
    alert: true,
    badge: true,
    sound: true,

  );

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => UserProvider()),
        ChangeNotifierProvider(create: (_) => BookingProvider()),
        ChangeNotifierProvider(create: (_) => NotifyProvider()),
        ChangeNotifierProvider(create: (_) => DrawerProvider()),

      ],
      child: MyApp(),
    ),
  );
}

 class MyApp extends StatelessWidget  {

 void  _firebaseCrashes()async{
    if (kDebugMode) {

      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(false);
    } else {


      await FirebaseCrashlytics.instance
          .setCrashlyticsCollectionEnabled(true);
    }
  }

   @override
  Widget build(BuildContext context) {
     _firebaseCrashes();
     whenMessageArrived(context);
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "نظام نقادة | العيادات",
      theme: ThemeData(
          appBarTheme: AppBarTheme(
              elevation: 0.0,
              color:primaryColor ,
              centerTitle: true,
              iconTheme: IconThemeData(color: Colors.white)),
          primaryColor:primaryColor ,
          fontFamily: "my_font" ),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child:ScreenController(),
      ),
    );
  }

SharedPreferences? prefs;


  whenMessageArrived(BuildContext context)
  {

    FirebaseMessaging.onMessage.forEach((RemoteMessage message) async{

      await setMessageData(message);

    });

    FirebaseMessaging.onMessageOpenedApp.forEach((RemoteMessage message) async{
      await setMessageData(message);

    });


    FirebaseMessaging.onBackgroundMessage((RemoteMessage message)  async{
      await setMessageData(message);
    });
  }
  setMessageData(RemoteMessage message)async{
     prefs = await SharedPreferences.getInstance();
     List<String> notifies= prefs!.getStringList("noti") ==null ?[]:prefs!.getStringList("noti")!;
     String messageIId=DateTime.now().millisecondsSinceEpoch.toString();
     RemoteNotification notification = message.notification!;

     flutterLocalNotificationsPlugin.show(
     notification.hashCode,
     notification.title,
     notification.body,
     NotificationDetails(
     android: AndroidNotificationDetails(
     channel.id,
     channel.name,
     channel.description,
     color: Colors.blue,
     playSound: true,
     icon: '@mipmap/ic_launcher',
     ),
     ));
     /* String? messageData;
    Uri uri = Uri.parse(message.data["redirectionLink"]);

    if(uri.hasQuery){
    uri.queryParameters.keys.forEach((element) {


    if(element=="id"){
    bool isNum;
    try{
    int.parse(uri.queryParameters["id"]!);
    isNum=true;
    }catch(ex){
      isNum =false;
    }

    if(isNum)
        messageData='{\"type\":\"booking\",\"id\":\"${ uri.queryParameters["id"]}\"}';
    else
        messageData='{\"type\":\"link\",\"link\":\"${message.data["redirectionLink"]}\"}';

    }


    });

    if(messageData ==null || messageData =="")
    messageData='{\"type\":\"link\",\"link\":\"${message.data["redirectionLink"]}\"}';

    }
    else
    messageData='{\"type\":\"link\",\"link\":\"${message.data["redirectionLink"]}\"}';

*/
     notifies.add('{\"messageId\":\"$messageIId\",\"link\":\"${message.data["redirectionLink"]}\",\"title\":\"${notification.title}\",\"body\":\"${notification.body}\",\"sendTime\":\"${message.sentTime}\"}');

     prefs!.setStringList("noti",notifies);
     //await notifyProvider.loadNotifyCount();
   }

}
