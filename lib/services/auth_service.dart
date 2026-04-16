import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  String? _verificationId;

  // =========================
  // 1. EMAIL LOGIN
  // =========================
  Future<bool> login(String input, String password) async {
    try {
      String email = input;

      // if user enters IC → find email first
      if (!input.contains('@')) {
        final query = await _db
            .collection('users')
            .where('ic', isEqualTo: input)
            .limit(1)
            .get();

        if (query.docs.isEmpty) return false;

        email = query.docs.first['email'];
      }

      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return true;
    } catch (e) {
      return false;
    }
  }

  // =========================
  // 2. REGISTER
  // =========================
  Future<String?> register({
    required String ic,
    required String email,
    required String password,
  }) async {
    try {
      UserCredential userCredential = await _auth
          .createUserWithEmailAndPassword(email: email, password: password);

      await _db.collection('users').doc(userCredential.user!.uid).set({
        'ic': ic,
        'email': email,
        'role': 'user',
        'createdAt': DateTime.now(),
      });

      return null;
    } catch (e) {
      return e.toString();
    }
  }

  // =========================
  // 3. SEND OTP (REAL)
  // =========================
  Future<bool> sendOtp(String phone) async {
    try {
      await FirebaseAuth.instance.verifyPhoneNumber(
        phoneNumber: '+60$phone',

        // Auto verify (Android only sometimes works)
        verificationCompleted: (PhoneAuthCredential credential) async {
          await FirebaseAuth.instance.signInWithCredential(credential);

          User? user = FirebaseAuth.instance.currentUser;
          if (user != null) {
            await ensureUserProfile(user);
          }
        },

        verificationFailed: (FirebaseAuthException e) {
          print("OTP Failed: ${e.code} - ${e.message}");
        },

        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          print("OTP SENT SUCCESS");
        },

        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },

        timeout: const Duration(seconds: 60),
      );

      return true;
    } catch (e) {
      print("Send OTP Error: $e");
      return false;
    }
  }

  // =========================
  // 4. VERIFY OTP (REAL)
  // =========================
  Future<bool> verifyOtp(String otp) async {
    try {
      if (_verificationId == null) {
        print("Verification ID is null");
        return false;
      }

      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: otp,
      );

      await FirebaseAuth.instance.signInWithCredential(credential);

      User? user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        await ensureUserProfile(user);
      }

      return true;
    } catch (e) {
      print("Verify OTP Error: $e");
      return false;
    }
  }

  // =========================
  // 5. LOGOUT
  // =========================
  Future<void> logout() async {
    await _auth.signOut();
  }

  // =========================
  // 6. CURRENT USER
  // =========================
  User? getCurrentUser() {
    return _auth.currentUser;
  }

  // =========================
  // 7. ENSURE USER PROFILE
  // =========================
  Future<void> ensureUserProfile(User user) async {
    final doc = await _db.collection('users').doc(user.uid).get();

    if (!doc.exists) {
      await _db.collection('users').doc(user.uid).set({
        'email': user.email ?? '',
        'role': 'user',
        'createdAt': DateTime.now(),
      });
    }
  }

  // =========================
  // 8. FORGOT PASSWORD
  // =========================
  Future<bool> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      return true;
    } catch (e) {
      print("Reset Password Error: $e");
      return false;
    }
  }

  // =========================
  // 9. GET FIREBASE TOKEN (IMPORTANT)
  // =========================
  Future<String?> getIdToken({bool forceRefresh = false}) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        return await user.getIdToken(forceRefresh);
      }
      return null;
    } catch (e) {
      print("Get Token Error: $e");
      return null;
    }
  }
}
