import 'package:clinic_admin/services/main_operations.dart';
import 'package:flutter/cupertino.dart';
class BookingProvider with ChangeNotifier{

  String url="https://ahmedmhassaan.000webhostapp.com/DoctorsDashboard/api/v1/includes/Bookings/";
  bool isLoading=false;
  String? error;
  MainOperation _mainOperation=MainOperation();

   String firstBookingIndex="noOne";
   String secondBookingIndex="0";


  refresh()
  {
    notifyListeners();
  }
  Future<bool> acceptBooking({String? bookingId,String? token,String? date,String? note}) async {

    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {"bookingId": bookingId!, "date": date!,"token":token! ,"note":note!};


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "accept.php");

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

  Future<bool> addBooking({String? token,String? doctorId,String? name}) async {

    print(doctorId!+token!);
    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {"docId":doctorId,"token":token ,"patientName": name!};


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "bookDoctorOutApp.php");

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
    }
  }

  Future<bool> refuseBooking({String? bookingId,String? token,String? note}) async {

    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {"bookingId": bookingId!, "note": note!,"token":token! };


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "refuse.php");

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


  Future<bool> finishBooking({String? bookingId,String? token,String? date}) async {

    isLoading=true;
    notifyListeners();

    Map<String, String> postData = {"bookingId": bookingId!,"token":token! ,"date":date!};


    Map<String, dynamic> resultMap = await _mainOperation.postOperation(
        postData, url + "finish.php");

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


    setFirstCardIndex(String index){
      firstBookingIndex=index;
    notifyListeners();
    }

  setSecondCardIndex(String index){
    secondBookingIndex=index;
    notifyListeners();
  }

  decreaseSecondCardByOne(){
    secondBookingIndex=(int.parse(secondBookingIndex)-1).toString();
    notifyListeners();
  }

}