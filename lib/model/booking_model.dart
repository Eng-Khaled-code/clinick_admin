class BookingModel
{

  String? bookingId;
  String? doctorId;
  String? bookingStatus;
  String? patientName;
  String? patientEmail;
  String? requestDate;
  String? date;
  String? acceptName;
  String? number;
  String? note;
  String? painSummary;
  String? type;
  BookingModel({this.patientEmail,this.type,this.requestDate,this.bookingId,this.bookingStatus,this.doctorId,this.patientName,this.date,this.acceptName,this.number,this.note,this.painSummary});

  factory BookingModel.fromSnapshot(Map<String,dynamic> data){
    return BookingModel
      (bookingId: data["BOOK_ID"]??"",
        doctorId: data["DOCTOR_ID"]??"",
        bookingStatus: data["BOOKING_STATUS"]??"",
        patientEmail: data["USERNAME"]??"",
        patientName: data["NAME"]??"",
        date: data["BOOKING_TIMESTAMP"]??"",
      acceptName: data["ACCEPT_NAME"]??"",
      number: data["NUM_IN_QUEUE"]??"0",
      note: data["NOTES"]??"",
      painSummary: data["PAIN_SUMMARY"]??"",
        requestDate: data["REQ_TIMESTAMP"]??"",
        type: data["TYPE"]??""
    );
  }

}