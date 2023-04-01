import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/model/user_model.dart';
import 'package:flutter/material.dart';
class TopContainer extends StatefulWidget {
  final UserModel? userModel;
  TopContainer({this.userModel});
  @override
  _TopContainerState createState() => _TopContainerState();
}

class _TopContainerState extends State<TopContainer> {

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;

    return Container(
      color: Colors.grey,
      height: height*.25,
      child: Stack(
        children: [Container(
decoration: BoxDecoration(color:"${widget.userModel!.imageUrl}" == ""
    ? Colors.transparent
          : Colors.grey,boxShadow: [BoxShadow(color: Colors.black)]),
    width: double.infinity,
    height: height * 0.25,
    child:"${widget.userModel!.imageUrl}" == ""
    ? logoImage(
    width: double.infinity,
    height: height * 0.25,)!
          : Image.network(
    "https://mumbaimirror.indiatimes.com/thumb/77794986.cms?resizemode=4&width=400",//"${widget.userModel!.imageUrl}",
    fit: BoxFit.cover,
    ),
    ),ClipRRect(
        borderRadius: BorderRadius.circular(60),
        child: Container(
                color:Colors.black,
                width: height * .16,
                height: height * .16,
                child: "${widget.userModel!.imageUrl}" == ""
                        ? logoImage(
    width: height * .16,
    height: height * .16,)!
                        : Image.network(
                          "https://mumbaimirror.indiatimes.com/thumb/77794986.cms?resizemode=4&width=400", // "${widget.userModel!.imageUrl}",
                            fit: BoxFit.cover,

                          ),
              )),]
      ),
    );
  }

}
