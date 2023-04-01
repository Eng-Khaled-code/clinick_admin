import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'dart:io';

class CardItem extends StatefulWidget {
  final String? title;
  final String? data;
  final String? doctorId;
  final String? token;
  CardItem({Key? key, this.title, this.data, this.doctorId,this.token}) : super(key: key);

  @override
  _CardItemState createState() => _CardItemState();
}

class _CardItemState extends State<CardItem> {

  @override
  Widget build(BuildContext context) {
    final _formKey = GlobalKey<FormState>();
    TextEditingController _controller= TextEditingController(text: "${widget.data}");

    return InkWell(
      onTap: () {

          showDialog(
              barrierDismissible: false,
              context: context,
              builder: (context) {
                UserProvider userProvider = Provider.of<UserProvider>(context);
                return Directionality(
                  textDirection: TextDirection.rtl,
                  child: AlertDialog(
                    scrollable: true,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    title: Text("تعديل ${widget.title}"),
                    content: Form(
                      key: _formKey,
                      child: TextFormField(
                              controller: _controller,
                              validator: (value) {
                                bool isNumber;
                                //checking is number or not
                                try {
                                  int.parse(value!);
                                  isNumber = true;
                                } catch (ex) {
                                  isNumber = false;
                                }

                                bool phoneTypeCon=
                                value!.startsWith("011")||value.startsWith("012")||value.startsWith("010")||value.startsWith("015");
                                bool phonePart1=(widget.title == "رقم الهاتف 1"|| widget.title == "رقم الهاتف 2" );
                                bool phoneCondition=(phonePart1&&(isNumber==false||value.length != 11||!phoneTypeCon));

                                if (value.isEmpty)
                                  return "لا يمكن ان يكون ${widget.title} فارغ";
                                else if ( phoneCondition)
                                  return "رقم الهاتف غير صحيح";
                              },
                              decoration: InputDecoration(
                                labelText: "${widget.title}",
                              ),
                            ),
                    ),
                    actions: <Widget>[
                      userProvider.isLoading
                          ? Container(
                              width: 17,
                              height: 17,
                              child: CircularProgressIndicator(
                                strokeWidth: 0.7,
                              ))
                          : FlatButton(
                              onPressed: () async {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    final result = await InternetAddress.lookup(
                                        'google.com');
                                    if (result.isNotEmpty &&
                                        result[0].rawAddress.isNotEmpty) {

                                      if(await updateField(text: _controller.text,user:userProvider)){
                                        Navigator.pop(context);
                                        await userProvider.loadUserData(doctorId: userProvider.userInformation!.doctorId,token: userProvider.userInformation!.token);
                                      }

                                }
                                  } on SocketException catch (_) {
                                    Fluttertoast.showToast(
                                        msg: "تأكد من إتصالك بالإنترنت",
                                        toastLength: Toast.LENGTH_LONG);
                                  }
                                }
                              },
                              child: Text("تعديل",style: TextStyle(color: primaryColor),)),
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("إلغاء")),
                    ],
                  ),
                );
              });

      },
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 21.0,
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(children: [
                  Icon(
                    widget.title == "الاسم"||widget.title=="المدير"
                        ? Icons.person
                        : widget.title == "رقم الهاتف 1"||widget.title=="رقم الهاتف 2"
                            ? Icons.phone
                            : widget.title == "عدد المرضي في اليوم الواحد"
                                ? Icons.group
                                : widget.title == "العنوان"
                                    ? Icons.location_on
                                    : widget.title == "التخصص"
                                        ? Icons.work
                                        : Icons.pageview,
                    size: MediaQuery.of(context).size.width * .08,
                    color: Colors.blue,
                  ),
                  SizedBox(width: 24.0),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        "${widget.title}",
                        style: TextStyle(
                          fontSize: 16.0,
                          color: primaryColor
                        ),
                      ),
                      SizedBox(height: 4.0),
                      Text(
                        "${widget.data}",
                        maxLines: 1,
                        style: TextStyle(
                          color: Colors.grey[700],
                          fontSize: 12.0,
                        ),
                      ),
                    ],
                  ),
                ]),
                Icon(
                  Icons.arrow_forward_ios,
                  size: 30.0,
                  color: Colors.blue,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<bool> updateField({String? text, UserProvider? user}) async {
    if (widget.title == "الاسم") {
      if (!await user!
          .updateDoctorName(doctorName: text)){
        Fluttertoast.showToast(msg: user.error!);
    return false;

    }
      else {
       Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
    return true;

    }
    } else if (widget.title == "رقم الهاتف 1") {

    if (!await user!
        .updatePhone1(phone:text)){
    Fluttertoast.showToast(msg: user.error!);
    return false;

    }else {
    Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
    return true;
    }
    } else if (widget.title == "رقم الهاتف 2") {
    if (!await user!
        .updatePhone2(phone:text)){
    Fluttertoast.showToast(msg: user.error!);
    return false;

    }
    else {
    Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
    return true;
    }
    } else if (widget.title == "عدد المرضي في اليوم الواحد") {
    if (!await user!
        .updateMaxPatient(num:text)){
    Fluttertoast.showToast(msg: user.error!);
    return false;

    }else {
    Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
    return true;
    }
    } else if (widget.title == "العنوان") {
    if (!await user!
        .updateAddres(address:text)){
    Fluttertoast.showToast(msg: user.error!);
    return false;

    }
    else {
    Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
    return true;
    }
    }
    else if (widget.title == "نبذه عن الدكتور") {
    if (!await user!
        .updateAboutDoctor(aboutDoctor:text)){
    Fluttertoast.showToast(msg: user.error!);
    return false;

    }
    else {
    Fluttertoast.showToast(msg: "تم تحديث ${widget.title} بنجاح ");
    return true;
    }
    }
    else{
      return false;
    }

  }
}
