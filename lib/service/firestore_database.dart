import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Veriyi Firestore'a kaydetme
  Future<void> saveUserData(String name,String surname , String email, String phone, String gender) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid; // Kullanıcının benzersiz ID'si

        // Bu ID ile Firestore'da kullanıcıya ait veriyi kaydetmek
        await _db.collection("users").doc(userId).set({
          'name': name,
          'surname':surname,
          'email': email,
          'phone': phone,
          'gender': gender,
        });
        print('Veri başarıyla kaydedildi.');
      } else {
        print("Kullanıcı oturum açmamış.");
      }
    } catch (e) {
      print('Veri kaydetme hatası: $e');
    }
  }
  Future<Map<String, dynamic>?> getUserData() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;  // Kullanıcının UID'si

        // Firestore'dan belgeyi getir
        DocumentSnapshot doc = await _db.collection("users").doc(userId).get();

        if (doc.exists) {
          print("Veri bulundu: ${doc.data()}");
          // Belge verilerini Map olarak döndür
          return doc.data() as Map<String, dynamic>;
        } else {
          print("Belge bulunamadı.");
          return null;
        }
      } else {
        print("Kullanıcı oturum açmamış.");
        return null;
      }
    } catch (e) {
      print('Veri çekme hatası: $e');
      return null;
    }
  }

}
