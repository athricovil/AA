import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'app_config.dart';
import 'user_session.dart';

class LoginPageContent extends StatefulWidget {
  @override
  _LoginPageContentState createState() => _LoginPageContentState();
}

class _LoginPageContentState extends State<LoginPageContent> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _login() async {
    if (_usernameController.text.trim().isEmpty || _passwordController.text.trim().isEmpty) {
      setState(() {
        _error = 'Both fields are required.';
      });
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });

    final response = await http.post(
      Uri.parse(AppConfig.apiBaseUrl + '/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
      }),
    );

    setState(() {
      _loading = false;
    });

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final username = data['username'] ?? _usernameController.text.trim();
      final userId = data['userId'];
      final token = data['token'];
      int parsedUserId = 0;
      if (userId != null) {
        if (userId is int) {
          parsedUserId = userId;
        } else if (userId is String) {
          parsedUserId = int.tryParse(userId) ?? 0;
        } else if (userId is double) {
          parsedUserId = userId.toInt();
        }
        await UserSession.saveUserSession(username, parsedUserId);
      }
      if (token != null) {
        await UserSession.saveToken(token);
      }
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Login successful!')));
      Navigator.pop(context, username);
    } else {
      setState(() {
        _error = 'Login failed. Please check your credentials.';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TextField(
          controller: _usernameController,
          decoration: InputDecoration(
            labelText: 'Username or email address',
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
          onPressed: _loading ? null : _login,
          child: _loading ? CircularProgressIndicator() : Text('Log in'),
        ),
        SizedBox(height: 10),
        TextButton(
          onPressed: () {
           
          },
          child: Text('Lost your password?'),
        ),
      ],
    );
  }
}