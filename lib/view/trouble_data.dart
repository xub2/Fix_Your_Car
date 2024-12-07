import 'dart:convert';

class TroubleData {
  String? symptom;
  String? vehiclePart;
  DateTime? date;

  TroubleData({
    this.symptom,
    this.vehiclePart,
    this.date,
  });

  // JSON 변환 메서드
  Map<String, dynamic> toJson() {
    return {
      'symptom': symptom,
      'vehiclePart': vehiclePart,
      'date': date?.toIso8601String(),
    };
  }

  // JSON으로부터 TroubleData 객체 생성
  factory TroubleData.fromJson(Map<String, dynamic> json) {
    return TroubleData(
      symptom: json['symptom'],
      vehiclePart: json['vehiclePart'],
      date: json['date'] != null ? DateTime.parse(json['date']) : null,
    );
  }

  // 차량 증상 정보를 특정 문자열 형식으로 변환하는 메서드
  String toQueryString() {
    String formattedDate = date != null ? "${date!.year}-${date!.month}-${date!.day}" : "알 수 없음";
    return "$symptom 증상이 차량의 $vehiclePart 부분에서 $formattedDate 부터 발생해. 원인과 해결 방법을 구체적으로 알려줘.";
  }

  @override
  String toString() {
    return jsonEncode(toJson()); // JSON 형태로 출력
  }
}
