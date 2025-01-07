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
        String userId = user.uid;
        await _db.collection("users").doc(userId).set({
          'name': name,
          'surname': surname,
          'email': email,
          'phone': phone,
          'gender': gender,
        });
      }
    } catch (e) {
      // Hata durumunda sadece işlemi başarısız olarak işaretle
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
          // Belge verilerini Map olarak döndür
          return doc.data() as Map<String, dynamic>;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
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
      }
    } catch (e) {
      return;
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

          return cards;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
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

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

//Adresi veritabanına kaydeden metot
  Future<void> saveAddress(String name, String surname, String phone,
      String city, String county, String address, String address_header) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        await _db
            .collection("users")
            .doc(userId)
            .collection("address")
            .doc()
            .set({
          'name': name,
          'surname': surname,
          'phone': phone,
          'city': city,
          'county': county,
          'address': address,
          'address_header': address_header,
        });
      }
    } catch (e) {
      // Hata durumunda sadece işlemi başarısız olarak işaretle
    }
  }

  //Adresi veritabanından getiren metot.
  Future<List<Map<String, dynamic>>?> getAddress() async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        QuerySnapshot querySnapshot = await _db
            .collection("users")
            .doc(userId)
            .collection("address")
            .get();

        if (querySnapshot.docs.isNotEmpty) {
          List<Map<String, dynamic>> address = querySnapshot.docs.map((doc) {
            Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
            data['documentId'] = doc.id;
            return data;
          }).toList();

          return address;
        } else {
          return null;
        }
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  //  adres silen metot
  Future<bool> deleteAddress(String documentId) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;

        await _db
            .collection("users")
            .doc(userId)
            .collection("address")
            .doc(documentId)
            .delete();

        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }

//adres güncelleyen metot
  Future<bool> updateAddress(
      String documentId,
      String name,
      String surname,
      String phone,
      String city,
      String county,
      String address,
      String addressHeader) async {
    try {
      User? user = _auth.currentUser;
      if (user != null) {
        String userId = user.uid;
        await _db
            .collection("users")
            .doc(userId)
            .collection("address")
            .doc(documentId)
            .update({
          'name': name,
          'surname': surname,
          'phone': phone,
          'city': city,
          'county': county,
          'address': address,
          'address_header': addressHeader,
        });
        return true;
      }
      return false;
    } catch (e) {
      return false;
    }
  }
}
