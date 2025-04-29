import 'package:flutter/material.dart';
class LoginPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          decoration: InputDecoration(
            labelText: 'Username or email address',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            // Handle login
          },
          child: Text('Log in'),
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () {
            // Handle forgot password
          },
          child: Text('Lost your password?'),
        ),
      ],
    );
  }
}