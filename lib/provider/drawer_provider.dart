import 'package:flutter/cupertino.dart';

class DrawerProvider with ChangeNotifier{

  String page='home';

  setPage(String toPage){
    page=toPage;
    notifyListeners();
  }

}