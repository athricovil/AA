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
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _whatsappController = TextEditingController();
  bool _loading = false;
  String? _error;

  Future<void> _signUp() async {
    // Validate all fields
    if (_usernameController.text.trim().isEmpty ||
        _passwordController.text.trim().isEmpty ||
        _phoneController.text.trim().isEmpty ||
        _whatsappController.text.trim().isEmpty) {
      setState(() {
        _error = 'All fields are required.';
      });
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    final response = await http.post(
      Uri.parse('http://localhost:8080/auth/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'username': _usernameController.text.trim(),
        'password': _passwordController.text.trim(),
        'phone': _phoneController.text.trim(),
        'whatsapp': _whatsappController.text.trim(),
      }),
    );

    setState(() {
      _loading = false;
    });

    if (response.statusCode == 200) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Registration successful! Please sign in.')),
      );
      await Future.delayed(Duration(seconds: 1));
      if (Navigator.canPop(context)) {
        Navigator.pop(context, 'show_signin'); // Pass a flag to parent to open sign-in
      }
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
    return Center(
      child: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(maxWidth: 400),
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 32),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black12,
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text("Don't have an account ?", style: TextStyle(fontSize: 24, fontWeight: FontWeight.w500)),
              SizedBox(height: 24),
              TextField(
                controller: _phoneController,
                decoration: InputDecoration(
                  labelText: 'Phone',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _usernameController,
                decoration: InputDecoration(
                  labelText: 'Username',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Password',
                  border: OutlineInputBorder(),
                ),
                obscureText: true,
              ),
              SizedBox(height: 16),
              TextField(
                controller: _whatsappController,
                decoration: InputDecoration(
                  labelText: 'WhatsApp',
                  border: OutlineInputBorder(),
                ),
                keyboardType: TextInputType.phone,
              ),
              SizedBox(height: 20),
              if (_error != null)
                Text(_error!, style: TextStyle(color: Colors.red)),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _loading ? null : _signUp,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black87,
                    padding: EdgeInsets.symmetric(vertical: 18),
                    shape: StadiumBorder(),
                  ),
                  child: _loading
                      ? CircularProgressIndicator(color: Colors.white)
                      : Text('Register', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                ),
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(child: Divider()),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text('OR'),
                  ),
                  Expanded(child: Divider()),
                ],
              ),
              SizedBox(height: 12),
              Text('You can also register with'),
              SizedBox(height: 12),
              Center(
                child: ElevatedButton(
                  onPressed: () async {
                    await _signInWithGoogle();
                  },
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    backgroundColor: Colors.white,
                    elevation: 2,
                    padding: EdgeInsets.all(12),
                  ),
                  child: Icon(Icons.g_mobiledata, size: 32, color: Colors.red),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}