import 'dart:io';
import 'package:clinic_admin/model/user_model.dart';
import 'package:clinic_admin/services/main_operations.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider with ChangeNotifier{

  String url="https://ahmedmhassaan.000webhostapp.com/DoctorsDashboard/api/v1/includes/Account/";
  String doctorDaysURL="https://ahmedmhassaan.000webhostapp.com/DoctorsDashboard/api/v1/includes/DoctorDays/";

  bool isLoading=false;
  String? error;
  String page='splach';
 // String? bookingId;
//user model get and set
  UserModel? userInformation;
  SharedPreferences? prefs;


  MainOperation _mainOperation=MainOperation();
  UserProvider(){
    checkLogIn();
    }

  checkLogIn()async{

      prefs=await SharedPreferences.getInstance();
      page= prefs!.getString("loged_in")==null?"loged_in":prefs!.getString("loged_in")=="loged_in"?"loged_in":"check_data";
      notifyListeners();
  }

  refresh() {
    notifyListeners();
  }

  setPage(String toPage){
    page=toPage;
    notifyListeners();
  }


  Future<bool> signIn(String email, String password) async {
  isLoading = true;
  notifyListeners();

  Map<String, String> postData = {"username": email, "password": password};

  Map<String, dynamic> resultMap =
  await _mainOperation.postOperation(postData, url + "login.php");

  print(resultMap);
  if (resultMap["code"] == 1) {
    prefs = await SharedPreferences.getInstance();
    prefs!.setString("doctor_id", "${resultMap["response"]}");

    page="check_data";
    isLoading=false;
    notifyListeners();
    return true;
  } else {
    error = resultMap["message"];
    isLoading=false;

    notifyListeners();
    return false;
  }
}

  Future<void> loadUserData({String? doctorId,String? token}) async {

    Map<String, String> postData = {"id": doctorId!, "token": token!};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(postData, url + "doctorData.php");
    print(resultMap["response"]);

    if (resultMap["code"] == 1)
      userInformation=UserModel.fromSnapshot(resultMap["response"]);
    else
      error=resultMap["message"];

    notifyListeners();

  }

  Future<bool> updateToken({String? doctorId,String? token}) async {
    print("in update token");
    Map<String, String> postData = {"id": doctorId!, "token": token!};

    Map<String, dynamic> resultMap =
    await _mainOperation.postOperation(postData, url + "updateToken.php");


    if (resultMap["code"] == 1) {

      return true;
    } else {
      error = resultMap["message"];
      print(error);
      notifyListeners();
      return false;
    }
  }

  Future<String> getToken()async{
    try {
      String ? token = await FirebaseMessaging.instance.getToken();
      return token!;
  }on FirebaseException catch(ex){
      print(ex.message);
      error=ex.message;
      return '';
    }
  }

  Future<bool> updatePlaceStatus({String? status,String? reason}) async {

    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {"status": status!, "id": userInformation!.doctorId!,"token":userInformation!.token!,"reason":reason!};


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "Update/changeClinicStatus.php");

    if (resultMap["code"] == 1) {
      //set user information
      isLoading=false;
      notifyListeners();
      return true;

    } else {
      error = resultMap["message"];
      isLoading=false;

      notifyListeners();
      return false;
    }  }
  Future<bool> updateDoctorName({String? doctorName}) async {

    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {"name": doctorName!, "id": userInformation!.doctorId!,"token":userInformation!.token! };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "Update/doctorName.php");

    if (resultMap["code"] == 1) {
      //set user information
      isLoading=false;
      notifyListeners();
      return true;

    } else {
      error = resultMap["message"];
      isLoading=false;

      notifyListeners();
      return false;
    }  }

  Future<bool> addWorkDay({String? to,String? from ,String? day}) async {
    bool? returnValue;
    isLoading=true;
    notifyListeners();
    try {
      final result = await InternetAddress.lookup(
          'google.com');
      if (result.isNotEmpty &&
          result[0].rawAddress.isNotEmpty) {

    Map<String, String> postData = {"token":userInformation!.token!,"day":day!,"doctorId": userInformation!.doctorId!,"to":to!,"from":from!};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, doctorDaysURL + "add.php");

    if (resultMap["code"] == 1) {
      //set user information
      isLoading=false;
      returnValue= true;

    } else {
      error = resultMap["message"];
      isLoading=false;
      returnValue= false;
    }
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "تأكد من إتصالك بالإنترنت", toastLength: Toast.LENGTH_LONG);
      isLoading=false;
      returnValue= false;

    }
    notifyListeners();

    return returnValue!;

      }

  Future<bool> updateWorkDay({String? dayId,String? to,String? from,String? day}) async {
    bool? returnValue;
    isLoading=true;
    notifyListeners();
    try {
      final result = await InternetAddress.lookup(
          'google.com');
      if (result.isNotEmpty &&
          result[0].rawAddress.isNotEmpty) {
        Map<String, String> postData = {
          "dayId": dayId!,
          "token": userInformation!.token!,
          "day": day!,
          "doctorId": userInformation!.doctorId!,
          "to": to!,
          "from": from!
        };

        Map<String, dynamic> resultMap = await _mainOperation.postOperation(
            postData, doctorDaysURL + "update.php");

        if (resultMap["code"] == 1) {
          //set user information
          isLoading = false;
          returnValue= true;
        } else {
          error = resultMap["message"];
          isLoading = false;
          returnValue= false;

        }
      }
    } on SocketException catch (_) {
      Fluttertoast.showToast(msg: "تأكد من إتصالك بالإنترنت", toastLength: Toast.LENGTH_LONG);
      isLoading=false;
      returnValue= false;

    }
    notifyListeners();
    return returnValue!;
      }

  Future<bool> deleteWorkDay({String? dayId}) async {

    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {"dayId": dayId!,"token":userInformation!.token!};

    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, doctorDaysURL + "delete.php");

    if (resultMap["code"] == 1) {
      //set user information
      isLoading=false;
      notifyListeners();
      return true;

    } else {
      error = resultMap["message"];
      isLoading=false;
      notifyListeners();

      return false;
    }  }

  Future<bool> updatePhone1({String? phone}) async {

    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {"phone": phone!, "id": userInformation!.doctorId!,"token":userInformation!.token! };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "Update/doctorPhone.php");

    if (resultMap["code"] == 1) {
      //set user information
    isLoading=false;
    notifyListeners();
    return true;

    } else {
    error = resultMap["message"];
    isLoading=false;

    notifyListeners();
    return false;
    }  }

  Future<bool> updatePhone2({String? phone}) async {

    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {"phone": phone!, "id": userInformation!.doctorId!,"token":userInformation!.token! };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "Update/assistantPhone.php");

    if (resultMap["code"] == 1) {
      //set user information
      isLoading=false;
      notifyListeners();
      return true;

    } else {
      error = resultMap["message"];
      isLoading=false;

      notifyListeners();
      return false;
    }  }

  Future<bool> updateMaxPatient({String? num}) async {

    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {"num": num!, "id": userInformation!.doctorId!,"token":userInformation!.token! };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "Update/maxPatients.php");

    if (resultMap["code"] == 1) {
      //set user information
      isLoading=false;
      notifyListeners();
      return true;

    } else {
      error = resultMap["message"];
      isLoading=false;

      notifyListeners();
      return false;
    }  }

  Future<bool> updateAddres({String? address}) async {

    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {"address": address!, "id": userInformation!.doctorId!,"token":userInformation!.token! };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "Update/clinicAddress.php");

    if (resultMap["code"] == 1) {
      //set user information
      isLoading=false;
      notifyListeners();
      return true;

    } else {
      error = resultMap["message"];
      isLoading=false;

      notifyListeners();
      return false;
    }  }

  Future<bool> updateAboutDoctor({String? aboutDoctor}) async {

    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {"details": aboutDoctor!, "id": userInformation!.doctorId!,"token":userInformation!.token! };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "Update/aboutDoctor.php");

    if (resultMap["code"] == 1) {
      //set user information
      isLoading=false;
      notifyListeners();
      return true;

    } else {
      error = resultMap["message"];
      isLoading=false;

      notifyListeners();
      return false;
    }  }

}
