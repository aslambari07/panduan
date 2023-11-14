import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

Future<String> createFirebaseUser(String emailAddress, String password) async {
  try {
    await FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: emailAddress,
      password: password,
    );
    return 'authentication-successful';
  } on FirebaseAuthException catch (e) {
    return e.code;
  }
}

Future<String> loginFirebaseUser(String emailAddress, String password) async {
  try {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: emailAddress, password: password);

    return 'authentication-successful';
  } on FirebaseAuthException catch (e) {
    return e.code.toString();
  }
}

Future<String> sendPasswordResetEmail(String emailAddress) async {
  try {
    await FirebaseAuth.instance.sendPasswordResetEmail(email: emailAddress);

    return 'password-reset-email-sent';
  } on FirebaseAuthException catch (e) {
    return e.code.toString();
  }
}

Future<String> sendVerificationEmail(String emailAddress) async {
  try {
    await FirebaseAuth.instance.currentUser!.sendEmailVerification();

    return 'verification-email-sent';
  } on FirebaseAuthException catch (e) {
    return e.code.toString();
  }
}

Future<String> googleSignIn() async {
  try {
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    await FirebaseAuth.instance.signInWithCredential(credential);

    return 'authentication-successful';
  } on FirebaseAuthException catch (e) {
    return e.code.toString();
  }
}
