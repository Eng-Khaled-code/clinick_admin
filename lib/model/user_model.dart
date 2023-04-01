class UserModel
{

  String? doctorId;
  String? doctorName;
  String? userName;
  String? doctorPhone;
  String? assistantPhone;
  String? maxPatient;
  String? address;
  String? imageUrl;
  String? doctorDegreee;
  String? aboutDoctor;
  String? adderName;
  String? locationImage;
  String? token;
  String? isInMySystem;
  List? workDays;
  List? specializations;
  List? ratings;
  String? likeCounter;
  String? ratingValue;
  String? placeStatus;
  UserModel({this.likeCounter,this.ratingValue,this.ratings,this.doctorId,this.adderName,this.doctorPhone,this.assistantPhone,this.maxPatient,this.address,
  this.imageUrl,this.doctorDegreee,this.aboutDoctor,this.locationImage,this.doctorName,this.userName,this.token,this.isInMySystem
  ,this.workDays,this.specializations,this.placeStatus
  });

  factory UserModel.fromSnapshot(Map<String,dynamic> data){
    return UserModel
      (doctorName: data["DOCTOR_NAME"]??"",
        doctorId: data["DOCTOR_ID"]??"",
        userName: data["USERNAME"]??"",
        doctorPhone: data["DOCTOR_PHONE"]??"",
        assistantPhone: data["ASSISTANT_PHONE"]??"",
      maxPatient: data["MAX_PATIENTS"]??"0",
      address: data["ADDRESS"]??"",
      imageUrl: data["DOCTOR_IMAGE"]??"",
      locationImage: data["LOCATION_IMAGE"]??"",
        doctorDegreee: data["DOCTOR_DEGREE"]??"",
        aboutDoctor: data["ABOUT_DOCTOR"]??"",
        adderName: data["ADDER_NAME"]??"",
        isInMySystem: data["IS_BELONG_TO_SYSTEM"]??"0",
        token: data["TOKEN"]??"",
        workDays: data["dates"]??[],
      specializations:data["specialists"]??[],
      ratings: data["comments"]??[],
      likeCounter: data["RATING"]??"0",
      ratingValue: data["LIKE_COUNT"]??"0",
      placeStatus: data["CLINIC_STATUS"].toString()

    );
  }

}