import 'package:google_sign_in/google_sign_in.dart';
import 'package:health_taylor/auth/google_login/google_social_login.dart';
import 'package:firebase_auth/firebase_auth.dart';

class GoogleLogin implements google_SocialLogin {
  User? firebaseUser;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  @override
  Future<User?> login() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    GoogleSignIn _googleSignIn = GoogleSignIn();

    try {
      final GoogleSignInAccount? googleAccount = await _googleSignIn.signIn();
      if (googleAccount != null) {
        final GoogleSignInAuthentication googleAuth =
            await googleAccount.authentication;
        final AuthCredential credential = GoogleAuthProvider.credential(
          accessToken: googleAuth.accessToken,
          idToken: googleAuth.idToken,
        );

        final UserCredential authResult =
            await _auth.signInWithCredential(credential);
        final User? user = authResult.user;

        if (user != null) {
          print("Google 로그인 성공: $user");
          /*await uploadGoogleUserInfoToFirestore(user);*/
          firebaseUser = user;
          return user;
        } else {
          print("Google 로그인 실패");
          return null;
        }
      }
    } catch (e) {
      print(e);
      return null;
    }

    return null;
  }

  @override
  Future<bool> logout() async {
    await _googleSignIn.signOut();
    firebaseUser = null;
    return true;
  }

  // Future<void> uploadGoogleUserInfoToFirestore(User? user) async {
  //   try {
  //     FirebaseFirestore firestore = FirebaseFirestore.instance;

  //     await firestore.collection('users').doc(user?.email).set({
  //       'displayName': user?.displayName,
  //       'email': user?.email,
  //       'photoURL': user?.photoURL,
  //     });
  //   } catch (e) {
  //     print('Error adding Google user to Firestore: $e');
  //   }
  // }
}
