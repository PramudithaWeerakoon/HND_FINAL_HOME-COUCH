import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthProvider1 {
  static Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Initialize GoogleSignIn with the Web Client ID
      final GoogleSignIn googleSignIn = GoogleSignIn(
        clientId:
            '277287963265-9gfe0uhb5u2aa88j7elju62t8uqsi7av.apps.googleusercontent.com',
      );

      // Perform the Google sign-in process
      final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
      final GoogleSignInAuthentication googleAuth =
          await googleUser!.authentication;

      // If the sign-in is successful, return the user's details
      if (googleUser != null && googleAuth.accessToken != null) {
        return {
          'email': googleUser.email,
          'name': googleUser.displayName,
          'id': googleUser.id,
        };
      } else {
        return null; // Return null if the user details are incomplete
      }
    } catch (e) {
      print('Error during Google Sign-In: $e');
      return null;
    }
  }
}
