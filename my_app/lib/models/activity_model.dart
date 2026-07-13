class ActivityModel {
  int activityId = 0;
  int exerciseId = 0;
  String exerciseName = "";
  int kcalExpense = 0;
  String activityDate = "";

  ActivityModel({
    required this.activityId,
    required this.exerciseId,
    required this.exerciseName,
    required this.activityDate,
    required this.kcalExpense,
  });

  DateTime getActivityDateTime() {
    DateFormat inputFormat = DateFormat('dd-MM-yyyy HH:mm:ss');
    DateTime dateTime = inputFormat.parse(activityDate);
    return dateTime;
  }

  factory ActivityModel.fromJson(Map<String, dynamic> json) {
    return ActivityModel(
      activityId: json['act_id'] as int,
      exerciseId: json['ex_id'] as int,
      exerciseName: json['ex_name'] as String,
      activityDate: json['act_date'] as String,
      kcalExpense: json['kcl_expense'] as int,
    );
  }
}

class getActivityResponse {
  bool isError = false;
  List<ActivityModel> data = [];
  String errorMessage = "";

  getActivityResponse({
    required this.isError,
    required this.data,
    required this.errorMessage,
  });

  factory getActivityResponse.fromJson(Map<String, dynamic> json) {
    return getActivityResponse(
      isError: json['isError'],
      // ดึงข้อมูลจากKey ''data มาแปลงเป็น list ของคลาส ActivityModel
      data: (json['data'] as List)
        .map((item) => ActivityModel.fromJson(item))
        .toList(),
      errorMessage: json['errorMessage'],
    ); //ActivityResponse
  }
}