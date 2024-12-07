import 'package:car_trouble/view/trouble_data.dart';
import 'package:flutter/material.dart';
import '../util/connect_manager.dart';
import 'result_view.dart';

class LoadingView extends StatelessWidget {
  final TroubleData troubleData;

  const LoadingView({Key? key, required this.troubleData, required String queryString}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    _sendQuery(context);
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 18, 32, 47),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(),
            SizedBox(height: 20),
            Text(
              "원인 분석 중...",
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }

  void _sendQuery(BuildContext context) async {
    final connectManager = ConnectManager();

    // troubleData.toQueryString()을 전달
    final response = await connectManager.sendQuery(troubleData.toQueryString());

    // 결과 화면으로 이동
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => ResultView(result: response ?? "원인 분석에 실패하였습니다 \n관리자에게 문의하세요."),
      ),
    );
  }
}
