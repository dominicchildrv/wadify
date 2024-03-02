import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_app/pages/home_page.dart';
import 'pages/start_page.dart';
import 'pages/home_page.dart';

void main() async {
    WidgetsFlutterBinding.ensureInitialized();
    SharedPreferences prefs = await SharedPreferences.getInstance();
  runApp(MyApp(token: prefs.getString('token')));
}

class MyApp extends StatelessWidget {

  final token;

  const MyApp({
    @required this.token,
    Key? key,

}): super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Start Page',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      //home: (JwtDecoder.isExpired(token) == false)?HomePage(token: token):StartPage(),
      home: StartPage(),
      debugShowCheckedModeBanner: false,
    );
  }
}


