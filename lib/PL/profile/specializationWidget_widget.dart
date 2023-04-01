import 'package:clinic_admin/PL/utilities/custom_text.dart';
import 'package:clinic_admin/constants.dart';
import 'package:flutter/material.dart';

class SpecializationWidget extends StatelessWidget {
  final List? specializations;

  SpecializationWidget({this.specializations});

  @override
  Widget build(BuildContext context) {
    print(specializations.toString());
    return Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
    child: Card(

    child:Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
      Padding(
        padding: const EdgeInsets.all(8.0),
        child: CustomText(text:"التخصص" ,fontWeight: FontWeight.bold,fontSize: 16,alignment: Alignment.topRight,),
      ),
        Container(
            padding: const EdgeInsets.all(8.0),

            width: double.infinity,
      height: 150,
      child:
      specializations==null?loadingWidget()!:specializations!.length==0?noDataCard():
          ListView.builder(shrinkWrap: true,scrollDirection: Axis.horizontal,itemCount:specializations!.length,itemBuilder: (context,position){
            return Item(specialization:specializations![position]["SPECIALTY"],itemId:specializations![position]["ID"] );

          })),
        ],
      )
    ));
  }

  Widget Item({String? specialization,String? itemId}){

    return  Material(
      borderRadius: BorderRadius.circular(10.0),

      elevation: 1,
      child: Container(

        margin:const EdgeInsets.all(12.0),
         padding: const EdgeInsets.all(8.0)
        ,width: 100,
        decoration:BoxDecoration(
          border: Border.all(color: primaryColor),
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10)),
        child:             CustomText(text:specialization! ,fontWeight: FontWeight.bold,fontSize: 16,),
          ),
    );


  }

  noDataCard(){
    return  Material(
      borderRadius: BorderRadius.circular(10.0),

      elevation: 1,
      child: Container(

        margin:const EdgeInsets.all(12.0),
        padding: const EdgeInsets.all(8.0)
        ,width: 100,
        decoration:BoxDecoration(
            border: Border.all(color: primaryColor),
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(10)),
        child:             CustomText(text:"لا يوجد تخصص"),
      ),
    );
  }
}
