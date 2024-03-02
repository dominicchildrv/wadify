import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:test_app/pages/userDetails_page.dart';
import 'home_page.dart';
import 'package:http/http.dart' as http;
import 'config.dart';
import 'login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  @override
  _SignUpPage createState() => _SignUpPage();
}



class _SignUpPage extends State<SignUpPage> {

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool _isNotValidate = false;
  final _formKey = GlobalKey<FormState>();

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


  void registerUser() async{

    if (_formKey.currentState!.validate()) {
      // Perform registration
      if(emailController.text.isNotEmpty && passwordController.text.isNotEmpty){

        var regBody = {
          "email":emailController.text,
          "password":passwordController.text
        };

        var response = await http.post(Uri.parse(registration),
            headers : {"Content-Type":"application/json"},
            body: jsonEncode(regBody)
        );

        var jsonResponse = jsonDecode(response.body);

        print(jsonResponse['status']);

        if(response.statusCode == 200 && jsonResponse['status']) {

          var regBody1 = {
            "email":emailController.text,
            "password":passwordController.text
          };

          var response1 = await http.post(Uri.parse(login),
              headers : {"Content-Type":"application/json"},
              body: jsonEncode(regBody1)
          );

          var jsonResponse1 = jsonDecode(response1.body);
          if(jsonResponse1['status']){
            var myToken = jsonResponse1['token'];
            prefs.setString('token', myToken);
            Navigator.push(context, MaterialPageRoute(builder: (context) => HomePage(token: myToken)));
          }else{
            print("Something went wrong");
          }
        } else{

          final snackBar = SnackBar(content: Text(jsonResponse['message'] ?? "An error occurred"));
          ScaffoldMessenger.of(context).showSnackBar(snackBar);

        }

      }else{
        setState(() {
          _isNotValidate = true;
        });
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Sign Up')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: emailController,
                decoration: InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r'\b[\w.-]+@[\w.-]+\.\w{2,4}\b').hasMatch(value)) {
                    return 'Please enter a valid email address';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: passwordController,
                decoration: InputDecoration(labelText: 'Password'),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty || !RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)[a-zA-Z\d]{8,}$').hasMatch(value)) {
                    return 'Password must be:\n-at least 8 characters long \n-at least one uppercase letter \n-at least one lowercase letter \n-at least one number';
                  }
                  return null;
                },
              ),
              ElevatedButton(
                onPressed: registerUser,
                child: Text('Sign Up'),
              ),
            ],
          ),
        ),
      ),
    );
  }


}
