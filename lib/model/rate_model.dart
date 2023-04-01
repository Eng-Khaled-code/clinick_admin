class RateModel
{

  String? rateId;
  String? doctorId;
  String? rate;
  String? date;
  String? comment;
  String? userName;
  String? name;
  String? commenterImage;

  RateModel({this.rateId,this.doctorId,this.rate,this.userName,this.date,this.comment,this.commenterImage,this.name});

  factory RateModel.fromSnapshot(Map<String,dynamic> data){
    return RateModel
      (rateId: data["ID"]??"",
        doctorId: data["DOCTOR_ID"]??"",
        rate: data["RATING_VALUE"]??"0",
        userName: data["USER_NAME"]??"0",
        date: data["RATING_TIMESTAMP"]??"",
      comment: data["COMMENT"]??"",
      commenterImage: data["IMAGE"]??"",
        name: data["NAME"]??""
    );
  }

}