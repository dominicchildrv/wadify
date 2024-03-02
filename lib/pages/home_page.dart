import 'package:flutter/material.dart';
import 'package:jwt_decoder/jwt_decoder.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'start_page.dart'; // Ensure you have this import if not already

class HomePage extends StatefulWidget {
  final String token;

  const HomePage({required this.token, Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late String email;

  @override
  void initState() {
    super.initState();
    Map<String, dynamic> jwtDecodedToken = JwtDecoder.decode(widget.token);
    email = jwtDecodedToken['email'];
  }

  // Method to handle logout logic
  void logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('token'); // This removes the token
    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) => StartPage()), (route) => false); // Navigates to StartPage and removes all the routes behind it
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: logout, // Call the logout method on press
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(email),
            SizedBox(height: 20),
            // Logout Button - Can also use a more prominent button if preferred
            ElevatedButton(
              onPressed: logout, // Call the logout method on press
              child: Text('Logout'),
            ),
          ],
        ),
      ),
    );
  }
}
