import 'package:clinic_admin/provider/booking_provider.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomAlertDialog extends StatelessWidget {
  final String? title;
  final String? text;
  final Function()? onPress;

  CustomAlertDialog(
      {@required this.title, @required this.text, @required this.onPress});

  @override
  Widget build(BuildContext context) {
    BookingProvider bookingProvider=Provider.of<BookingProvider>(context);
    UserProvider userProvider=Provider.of<UserProvider>(context,listen: false);

    return Directionality(
        textDirection: TextDirection.rtl,
        child:AlertDialog(
          title: Text(
            title!,
            style: TextStyle(fontSize: 16),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: Text("إلغاء"))
            ,bookingProvider.isLoading||userProvider.isLoading?Container(
                width: 17,
                height: 17,
                child: CircularProgressIndicator(
                  strokeWidth: 0.7,
                )):TextButton(onPressed: onPress, child: Text("تأكيد"))
          ],
          content: Text(
            text!,
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ));
  }
}
