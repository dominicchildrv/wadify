import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'dart:convert';


class LoginPage extends StatefulWidget{
  @override

  _loginPageState createState() => _loginPageState();
}

class _loginPageState extends State<LoginPage>{

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;

  late SharedPreferences prefs;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    initSharedPref();
  }

  void initSharedPref() async{
    prefs = await SharedPreferences.getInstance();
  }

  void loginUser() async{
    if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){

      var regBody = {
        "email":emailController.text,
        "password":passwordController.text
      };

      var response = await http.post(Uri.parse(login),
          headers : {"Content-Type":"application/json"},
          body: jsonEncode(regBody)
      );

      var jsonResponse = jsonDecode(response.body);
      if(jsonResponse['status']){
          var myToken = jsonResponse['token'];
          prefs.setString('token', myToken);
          Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(token: myToken)));
      }else{
        print("Something went wrong");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Log In'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email',errorText: _isNotValidate ? "Invalid Email" : null),
            ),
            SizedBox(height: 20),
            TextField(
              controller: passwordController,
              decoration: InputDecoration(labelText: 'Password', errorText: _isNotValidate ? "Invalid Password" : null),
              obscureText: true,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add authentication logic here
                loginUser();
              },
              child: Text('Log In'),
            ),
          ],
        ),
      ),
    );
  }


}

