import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class FirebaseService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Veriyi Firestore'a kaydetme
  Future<void> saveUserData(String name, String surname, String email,
      String phone, String gender) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid; // Kullanıcının benzersiz ID'si

        // Bu ID ile Firestore'da kullanıcıya ait veriyi kaydetmek
        await _db.collection("users").doc(userId).set({
          'name': name,
          'surname': surname,
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
        String userId = user.uid; // Kullanıcının UID'si

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

// Kredi kartını veri tabanına kaydeden metot
  Future<void> saveCreditCard(String cardName, String cardNo, String validThru,
      String CVV, String holder) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        await _db
            .collection("users")
            .doc(userId)
            .collection("cards")
            .doc()
            .set({
          'cardName': cardName,
          'cardNo': cardNo,
          'validThru': validThru,
          'CVV': CVV,
          'holder': holder
        });
        print('Kart başarıyla kaydedildi.');
      } else {
        print("Kullanıcı oturum açmamış.");
      }
    } catch (e) {
      print('Kart kaydedilirken bir hata oluştu : $e');
      return null;
    }
  }

  //Kredi kartlarını getirme
  Future<List<Map<String, dynamic>>?> getCreditCard() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        QuerySnapshot querySnapshot =
            await _db.collection("users").doc(userId).collection("cards").get();

        if (querySnapshot.docs.isNotEmpty) {
          List<Map<String, dynamic>> cards = querySnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data['documentId'] = doc.id;
            return data;
          }).toList();

          print("Kartlar bulundu");
          return cards;
        } else {
          print("Kart bulunumadı.");
          return null;
        }
      } else {
        print("Kullanıcı oturum açmamış.");
        return null;
      }
    } catch (e) {
      print("Veri çekme hatası : $e");
      return null;
    }
  }

  // Kredi kartını veri tabanından silen metot
  Future<bool> deleteCreditCard(String documentId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        // Document ID ile doğrudan silme işlemi
        await _db
            .collection("users")
            .doc(userId)
            .collection("cards")
            .doc(documentId)
            .delete();

        print('Kart başarıyla silindi.');
        return true;
      } else {
        print("Kullanıcı oturum açmamış.");
        return false;
      }
    } catch (e) {
      print('Kart silinirken bir hata oluştu: $e');
      return false;
    }
  }
}
