
import 'package:appetit/screens/LoginScreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  signInWithGoogle() async {
    // final GoogleSignInAccount? gUser = await GoogleSignIn().signIn();
    // final GoogleSignInAuthentication gAuth = await gUser!.authentication;
    // final credential = GoogleAuthProvider.credential(
    //   accessToken: gAuth.accessToken,
    //   idToken: gAuth.idToken
    // );
    // return await FirebaseAuth.instance.signInWithCredential(credential);
    // return gAuth.idToken;

    final GoogleSignInAccount? googleSignInAccount =
    await GoogleSignIn().signIn();

    if (googleSignInAccount != null) {
      final GoogleSignInAuthentication
      googleSignInAuthentication =
      await googleSignInAccount.authentication;
      final AuthCredential credential =
      GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential userCredential = await FirebaseAuth
          .instance
          .signInWithCredential(credential);

      final User user = userCredential.user!;
      final String? idToken = await user.getIdToken();
      return idToken;
    }
  }

  Future<void> signOut(BuildContext context) async {
  final GoogleSignIn _googleSignIn = GoogleSignIn();
  try {
    await _googleSignIn.signOut();
    await FirebaseAuth.instance.signOut();
    Navigator.pushReplacementNamed(context, LoginScreen.routeName);
  } catch (error) {
    print('Error during Google sign out: $error');
  }
}
}