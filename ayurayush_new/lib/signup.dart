import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
class SignupPageContent extends StatelessWidget {
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> _signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        // The user canceled the sign-in
        return;
      }

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // You can use googleAuth.accessToken and googleAuth.idToken to authenticate with your backend server

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
          decoration: InputDecoration(
            labelText: 'Email address',
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
            // Handle register
          },
          child: Text('Register'),
        ),
        const SizedBox(width: 18),
       Padding(
  padding: const EdgeInsets.only(top: 20),
  child: ElevatedButton(
          onPressed: () async {
            await _signInWithGoogle();
          },
          child: Text("Sign In with Google",
                          style: TextStyle(
                            fontSize: 16,
                            color: Colors.purple,
                          ),
                        ),
        ))
        
        
      ],
    );
  }
}

