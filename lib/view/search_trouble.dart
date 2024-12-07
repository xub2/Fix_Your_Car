import 'package:flutter/material.dart';
import 'package:intl/intl.dart'; // 날짜 형식을 다루기 위한 패키지
import 'loading_view.dart';
import 'trouble_data.dart'; // trouble_data.dart 파일을 import

class SearchTroublePage extends StatefulWidget {
  @override
  _SearchTroublePageState createState() => _SearchTroublePageState();
}

class _SearchTroublePageState extends State<SearchTroublePage> {
  // 입력 필드에 대한 컨트롤러
  final TextEditingController _symptomController = TextEditingController();
  final TextEditingController _vehiclePartController = TextEditingController();

  // 선택된 날짜 변수
  DateTime? _selectedDate;

  // 날짜 선택을 위한 함수
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _selectedDate)
      setState(() {
        _selectedDate = picked;
      });
  }

  // '다음으로' 버튼이 눌렸을 때
  void _onNextPressed() {
    if (_symptomController.text.isNotEmpty &&
        _vehiclePartController.text.isNotEmpty &&
        _selectedDate != null) {
      // 입력된 데이터를 TroubleData 모델에 저장
      final troubleData = TroubleData(
        symptom: _symptomController.text,
        vehiclePart: _vehiclePartController.text,
        date: _selectedDate,
      );

      // 데이터가 유효하면 Loading 화면으로 넘어가기
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => LoadingView(
            troubleData: troubleData,
            queryString: troubleData.toQueryString(), // Query string 전달
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xFF121F2F), // 동일한 색상
        title: Text("증상 검색하기"),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () {
            Navigator.pop(context); // 뒤로 가기 버튼
          },
        ),
      ),
      backgroundColor: Color(0xFF121F2F), // 동일한 색상
      body: SingleChildScrollView( // 스크롤 가능하게 수정
        padding: const EdgeInsets.all(16.0), // 여백을 추가하여 깔끔하게 배치
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // 텍스트 추가
            Text(
              "자주 찾는 증상에 증상이 없나요?\n그렇다면 증상을 알려주세요!",
              style: TextStyle(
                color: Colors.white, // 텍스트 색상 흰색
                fontSize: 24, // 텍스트 크기
                fontWeight: FontWeight.bold, // 텍스트 굵기
              ),
            ),
            SizedBox(height: 20), // 텍스트와 입력 필드 사이에 간격

            // 증상 입력 칸
            TextField(
              controller: _symptomController,
              decoration: InputDecoration(
                hintText: '증상을 입력해주세요',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              ),
            ),
            SizedBox(height: 20),

            Text(
              "증상이 구체적이면 구체적일수록 좋아요.",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            Divider(color: Colors.grey, thickness: 1, height: 20),

            // 차량 부위 입력 안내
            Text(
              "차량의 어느 부분에서 증상이 발생하나요?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // 차량 부위 입력 칸
            TextField(
              controller: _vehiclePartController,
              decoration: InputDecoration(
                hintText: '증상이 나타나는 부분을 입력해주세요',
                filled: true,
                fillColor: Colors.white,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                ),
                contentPadding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 12.0),
              ),
            ),
            SizedBox(height: 20),

            Text(
              "증상이 발생하는 위치에 따라 문제점이 달라질 수도 있어요",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            Divider(color: Colors.grey, thickness: 1, height: 20),

            // 날짜 선택 안내
            Text(
              "증상이 언제부터 발생했나요?",
              style: TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // 날짜 선택 위젯
            Row(
              children: [
                ElevatedButton(
                  onPressed: () => _selectDate(context),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.black, backgroundColor: Colors.white,
                  ),
                  child: Text(
                    _selectedDate == null
                        ? '날짜 선택하기'
                        : DateFormat('yyyy-MM-dd').format(_selectedDate!),
                  ),
                ),
                Text(
                  " 경 증상 발생 시작",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Text(
              "\n구체적인 날짜가 아니어도 괜찮아요 \n대략적인 날짜를 알려주세요",
              style: TextStyle(
                color: Colors.grey,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),

            // '다음으로' 버튼
            ElevatedButton(
              onPressed: _onNextPressed,
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black, backgroundColor: Colors.white,
              ),
              child: Text('다음으로'),
            ),
          ],
        ),
      ),
    );
  }
}
