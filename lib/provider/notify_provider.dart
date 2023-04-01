
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
class NotifyProvider with ChangeNotifier{
  bool isLoading=false;
  String? error;
  SharedPreferences? prefs;
  //int notifCount=0;

  Future<List> loadNotifyList() async{

    prefs=await SharedPreferences.getInstance();
    List noti= prefs!.getStringList("noti")==null?[]:prefs!.getStringList("noti")!;
    noti= List.from(noti.reversed);
    //notifyListeners();
    return noti;
  }

  refresh()
  {
    notifyListeners();
  }
/*
  Future<int> loadNotifyCount()async
  {
    prefs=await SharedPreferences.getInstance();
    String lastDate= prefs!.getString("last_date")==null?"0":prefs!.getString("last_date")!;
    List notifies= prefs!.getStringList("noti")==null?[]:prefs!.getStringList("noti")!;

    if(lastDate=="0")
       notifCount=notifies.length;
    else{
  notifies.forEach((element) {


  Map <String,dynamic> notify=jsonDecode(element);

  notifCount=DateTime.parse(notify["sendTime"]).isAfter(DateTime.parse(lastDate))?notifCount++:notifCount;

  });
  }
   notifyListeners();
   return notifCount;
  }*/

}