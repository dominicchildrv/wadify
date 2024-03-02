import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'config.dart'; // Make sure this file exists and contains your API endpoint configurations
import 'home_page.dart';
import 'dart:convert';

class UserDetailsPage extends StatefulWidget {
  final String token;

  UserDetailsPage({required this.token});

  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  TextEditingController ageController = TextEditingController();
  String? sex; // Nullable to allow for an initial 'no selection' state

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Complete Your Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              TextFormField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: 'Name',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your name';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              TextFormField(
                controller: ageController,
                decoration: InputDecoration(
                  labelText: 'Age',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your age';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<String>(
                value: sex,
                decoration: InputDecoration(
                  labelText: 'Sex',
                  border: OutlineInputBorder(),
                ),
                items: <String>['Male', 'Female'].map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (newValue) => setState(() => sex = newValue),
                validator: (value) => value == null ? 'Please select your sex' : null,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: submitDetails,
                child: Text('Submit'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void submitDetails() async {
    if (_formKey.currentState!.validate()) {
      var response = await http.post(
        Uri.parse(updateDetails), // Adjust this to your actual update details endpoint
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${widget.token}",
        },
        body: jsonEncode({
          "name": {"first": nameController.text, "last": ""}, // Adjust if your backend expects a different format
          "sex": sex,
          "age": int.parse(ageController.text),
        }),
      );

      if (response.statusCode == 200) {
        Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (_) => HomePage(token: widget.token)));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to update user details. Please try again.')),
        );
      }
    }
  }
}
