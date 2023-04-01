
class NotifyModel
{

  String? messageId;
  String? title;
  String? body;
  String? sendTime;
  String? redirectionLink;

  // Map<String,dynamic>? notiData;

  NotifyModel({this.messageId,this.title,this.body,this.sendTime,this.redirectionLink});

 NotifyModel.fromSnapshot(Map<String,dynamic> data){
   messageId=data["messageId"]??"";
   title=data["title"]??"لا يوجد عنوان";
   //notiData=data["data"]??"";
   body=data["body"]??"لا توجد تفاصيل";
   sendTime=data["sendTime"]??"";
   redirectionLink=data["link"]??"https://ahmedmhassaan.000webhostapp.com";
 }
}