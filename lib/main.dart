import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'view/map_view.dart';
import 'view/search_trouble.dart';

void main() async {
  await dotenv.load(fileName: '.env');
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // 디버그 배너 제거
      home: MainScreen(),
      routes: {
        '/map_view': (context) => MapView(),
        '/search_trouble': (context) => SearchTroublePage(),
      },
    );
  }
}

class MainScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF121F2F), // 배경 색상
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // 사진 경로만 변경하면 되는 부분
            Image.asset(
              'assets/fixcarlogo.png', // 이미지 경로
              height: 350,
              width: 350, // 이미지 크기
              errorBuilder: (context, error, stackTrace) {
                return const Text(
                  'Logo Image Not Found',
                  style: TextStyle(color: Colors.white),
                ); // 이미지가 없을 경우 대체 텍스트 표시
              },
            ),
            const SizedBox(height: 40), // 이미지와 버튼 간격
            // 버튼들을 가로로 배열 (정사각형 버튼으로 만들기)
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // 첫 번째 버튼: 증상 검색하기
                _buildImageButton(
                  context,
                  'assets/search.png', // 버튼 이미지 경로
                      () {
                    Navigator.pushNamed(context, '/search_trouble');
                  },
                ),
                const SizedBox(width: 20), // 버튼 간격

                // 두 번째 버튼: 주변 공업사 보기
                _buildImageButton(
                  context,
                  'assets/carmap.png', // 버튼 이미지 경로
                      () {
                    Navigator.pushNamed(context, '/map_view');
                  },
                ),
                const SizedBox(width: 20), // 버튼 간격
                // 세 번째 버튼: 앱 종료
                _buildImageButton(
                  context,
                  'assets/exit.png', // 버튼 이미지 경로
                      () {
                    SystemNavigator.pop(); // 앱 종료
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // 이미지 버튼을 생성하는 공통 함수
  ElevatedButton _buildImageButton(
      BuildContext context,
      String imagePath, // 이미지 경로
      VoidCallback onPressed,
      ) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.all(0), // 기본 색상 제거
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), // 둥근 모서리 추가
        ),
      ),
      onPressed: onPressed,
      child: Container(
        width: 100, // 버튼 너비를 100으로 설정 (정사각형)
        height: 100, // 버튼 높이를 100으로 설정 (정사각형)
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage(imagePath), // 이미지 설정
            fit: BoxFit.cover, // 이미지 비율 맞추기
          ),
        ),
      ),
    );
  }
}
