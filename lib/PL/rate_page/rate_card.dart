import 'package:clinic_admin/PL/utilities/custom_text.dart';
import 'package:clinic_admin/constants.dart';
import 'package:clinic_admin/model/rate_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:timeago/timeago.dart' as timeago;

class RateCard extends StatelessWidget {
  final RateModel? model;
  RateCard({this.model});

  @override
  Widget build(BuildContext context) {
    final difference = DateTime.now().difference(DateTime.parse(model!.date!));

    return  Padding(
      padding: const EdgeInsets.all(8.0),
      child:Material(
    elevation: 2,
    color: Colors.white,
    borderRadius: BorderRadius.circular(10),

    child: Column(
     mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,

      children: [
  Padding(
    padding: const EdgeInsets.all(8.0),
    child: Row(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment:CrossAxisAlignment.start,
      children: [
      CircleAvatar(backgroundImage:NetworkImage(model!.commenterImage!)),
         Padding(
           padding: const EdgeInsets.only(bottom: 20.0,right: 8.0),
           child: Column(
             crossAxisAlignment: CrossAxisAlignment.start,
             children: [
               Text(model!.name!+" ",style: TextStyle(color: primaryColor,fontWeight: FontWeight.bold,fontSize: 16)),
     CustomText(text:model!.userName!,fontSize: 12,alignment: Alignment.centerRight,color: Colors.grey,),
    CustomText(text:  "  "+timeago.format(DateTime.now().subtract(difference), locale: 'ar'),fontSize: 12,alignment: Alignment.centerRight,color: Colors.grey,),

             ],
           ),
         )
        ],
      ),
  ),               Padding(
    padding: const EdgeInsets.all(8.0),
    child: Text(model!.comment!,style:TextStyle(color: Colors.grey)),
  ),

  Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Text("التقييم : "),
        Text("5/"),

        Text(model!.rate.toString(),style: TextStyle(color: primaryColor,fontSize: 30,fontWeight: FontWeight.bold),),
  SizedBox(width: 15,),
  RatingBar.builder(initialRating: double.parse(model!.rate!),
            ignoreGestures: true,
            itemSize: 25,
            direction: Axis.horizontal,allowHalfRating: true
            ,itemCount: 5,itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context,_)=>Icon(Icons.star,color: Colors.amber,),onRatingUpdate: (rating){},)
        ],
      ),
    ),
      ],
    )
    )
    );
  }



}
