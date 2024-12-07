import 'package:flutter/material.dart';

class ResultView extends StatelessWidget {
  final String result;

  const ResultView({Key? key, required this.result}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 32, 47), // 배경 색상
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 18, 32, 47), // AppBar 배경 색상을 동일하게 설정
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
        title: const Text(
          "분석 완료",
          style: TextStyle(
            fontWeight: FontWeight.bold, // 텍스트를 볼드체로 설정
            color: Colors.white,
          ),
        ),
        elevation: 0, // AppBar 그림자 제거
      ),
      body: SingleChildScrollView( // 스크롤 가능하도록 추가
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                result.split('\n').first,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                result.split('\n').skip(1).join('\n').replaceAll('**', ''),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 30), // 버튼과 텍스트 간격
              // map_view로 넘어가는 버튼 추가
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white, // 버튼 배경색
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/map_view'); // map_view 페이지로 이동
                },
                child: const Text('주변 공업사 확인하기')// 버튼 텍스트
              ),
            ],
          ),
        ),
      ),
    );
  }
}
