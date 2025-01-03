import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Auth {
  final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  User? get currentUser => _firebaseAuth.currentUser;
  Stream<User?> get authStateChanges => _firebaseAuth.authStateChanges();


    // Güvenlik açıkları nedeniyle fetchSignInMethodsForEmail artıl kullanılmaması öneriliyor fakat
    // yerine kullanılabilecek alternatifler olsa da yapmayı beceremedim.
  Future<bool> isEmailRegistered(String email) async {
    try {
      List<String> signInMethods =
      await _firebaseAuth.fetchSignInMethodsForEmail(email);
      return signInMethods.isNotEmpty; // Eğer boş değilse, kullanıcı mevcut
    } catch (e) {
      print('Hata: $e');
      return false;
    }
  }

  // Register
  Future<void> createUser({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.createUserWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Login
  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    await _firebaseAuth.signInWithEmailAndPassword(
      email: email,
      password: password,
    );
  }

  // Google ile Giriş
  Future<User?> signInWithGoogle() async {
    try {
      // Google giriş işlemi başlatılıyor
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null; // Kullanıcı giriş yapmazsa null döner
      }
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Firebase ile Google giriş bilgilerini doğruluyoruz
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Firebase ile oturum açıyoruz
      final UserCredential userCredential = await _firebaseAuth.signInWithCredential(credential);
      return userCredential.user;
    } catch (e) {
      print("Google ile giriş hatası: $e");
      return null;
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _firebaseAuth.signOut();
  }
}
