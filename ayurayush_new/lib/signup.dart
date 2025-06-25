import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignupPageContent extends StatefulWidget {
  @override
  _SignupPageContentState createState() => _SignupPageContentState();
}

class _SignupPageContentState extends State<SignupPageContent> {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _signUp() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final response = await http.post(
      Uri.parse('https://localhost:8080/signup'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': _emailController.text,
        'password': _passwordController.text,
      }),
    );

    setState(() {
      _loading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Signup successful!')));
    } else {
      setState(() {
        _error = 'Signup failed. Please try again.';
      });
    }
  }

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return;
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      // Send googleAuth.idToken or googleAuth.accessToken to your backend if needed
      print('Signed in with Google: ${googleUser.displayName}');
    } catch (error) {
      print('Failed to sign in with Google: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _emailController,
          decoration: InputDecoration(
            labelText: 'Email address',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(height: 10),
        TextField(
          controller: _passwordController,
          decoration: InputDecoration(
            labelText: 'Password',
            border: OutlineInputBorder(),
          ),
          obscureText: true,
        ),
        SizedBox(height: 10),
        if (_error != null)
          Text(_error!, style: TextStyle(color: Colors.red)),
        ElevatedButton(
          onPressed: _loading ? null : _signUp,
          child: _loading ? CircularProgressIndicator() : Text('Register'),
        ),
        const SizedBox(height: 18),
        Padding(
          padding: const EdgeInsets.only(top: 20),
          child: ElevatedButton(
            onPressed: () async {
              await _signInWithGoogle();
            },
            child: Text(
              "Sign In with Google",
              style: TextStyle(
                fontSize: 16,
                color: Colors.purple,
              ),
            ),
          ),
        ),
      ],
    );
  }
}