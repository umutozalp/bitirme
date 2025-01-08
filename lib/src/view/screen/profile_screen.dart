import 'package:bitirme/service/auth.dart';
import 'package:bitirme/src/view/screen/address_screen.dart';
import 'package:bitirme/src/view/screen/home_screen.dart';
import 'package:bitirme/src/view/screen/payment_methods_screen.dart';
import 'package:bitirme/src/view/screen/user_info_screen.dart';
import 'package:flutter/material.dart';
import 'package:bitirme/src/view/screen/login_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  // Kullanıcı bilgileri
  Map<String, String> userInfo = {
    "name": "",
    "email": "",
    "phone": "",
  };

  @override
  Widget build(BuildContext context) {
    final currentUser = Auth().currentUser;
    if (currentUser == null) {
      return const LoginRegisterPage();
    } else {
      // Kullanıcı bilgilerini güncelle
      userInfo = {
        "name": currentUser.displayName ?? "Ad Bulunamadı",
        // null olması durumunda varsayılan değer
        "email": currentUser.email ?? "Email Bulunamadı",
        "phone": currentUser.phoneNumber ?? "Telefon Bulunamadı",
      };
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: Color.fromRGBO(10, 61, 51, 1.0),
        title: Text(
          "Profil",
          style: TextStyle(
              fontSize: 23, fontWeight: FontWeight.w600, color: Colors.white),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profil fotoğrafı ve kullanıcı adı - Card içine alındı
            Card(
              elevation: 5,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40,
                      backgroundColor: Color.fromRGBO(10, 61, 51, 1.0),
                      child: Icon(
                        Icons.person,
                        color: Color.fromRGBO(255, 255, 255, 1.0),
                        size: 50,
                      ),
                    ),
                    SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Umut Özalp",
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userInfo["email"] ?? "Email Bulunamadı",
                          style: TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 5),
            Divider(color: Colors.grey[300], thickness: 1),
            SizedBox(height: 5),
            // Kullanıcı bilgileri sekmesi
            _buildProfileOption(
              icon: Icon(Icons.edit, color: Color.fromRGBO(10, 61, 51, 1.0),),
              context,
              title: "Kullanıcı Bilgilerim",
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        UserInfo(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // FadeTransition ile ekranın opaklığını değiştirme
                      return FadeTransition(
                        opacity: animation, // Opaklık animasyonu
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),

            _buildProfileOption(
              icon: Icon(Icons.home, color: Color.fromRGBO(10, 61, 51, 1.0),),
              context,
              title: "Adreslerim",
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        AddressScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // FadeTransition ile ekranın opaklığını değiştirme
                      return FadeTransition(
                        opacity: animation, // Opaklık animasyonu
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),

            // Geçmiş Siparişler sekmesi
            _buildProfileOption(
              icon: Icon(Icons.history, color: Color.fromRGBO(10, 61, 51, 1.0),),
              context,
              title: "Geçmiş Siparişlerim",
              onTap: () {},
            ),

            _buildProfileOption(
              icon: Icon(Icons.credit_card, color: Color.fromRGBO(10, 61, 51, 1.0),),
              context,
              title: "Ödeme Yöntemlerim",
              onTap: () {
                Navigator.push(
                  context,
                  PageRouteBuilder(
                    pageBuilder: (context, animation, secondaryAnimation) =>
                        PaymentScreen(),
                    transitionsBuilder:
                        (context, animation, secondaryAnimation, child) {
                      // FadeTransition ile ekranın opaklığını değiştirme
                      return FadeTransition(
                        opacity: animation, // Opaklık animasyonu
                        child: child,
                      );
                    },
                  ),
                );
              },
            ),
            _handleLogout(context),
          ],
        ),
      ),
    );
  }

  // Profil seçeneklerini oluşturan fonksiyon
  Widget _buildProfileOption(BuildContext context,
      {required String title, required Function() onTap, required Icon icon}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 80,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3), //DEĞİŞTİRİLEBİLİR LA BAK
            ),
          ],
        ),
        child: Row(
          children: [
            icon,
            SizedBox(width: 3),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 18, color: Color.fromRGBO(10, 61, 51, 1.0),),
          ],
        ),
      ),
    );
  }

  Widget _handleLogout(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await Auth().signOut();
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const HomeScreen()),
        );
      },
      child: Container(
        height: 70,
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.2),
              spreadRadius: 1,
              blurRadius: 8,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Row(children: [
          Icon(
            Icons.logout,
            color: Color.fromRGBO(10, 61, 51, 1.0),
          ),
          SizedBox(width: 3),
          Expanded(
            child: Text(
              "Çıkış Yap",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
            ),
          ),
          Icon(Icons.arrow_forward_ios, size: 18, color: Color.fromRGBO(10, 61, 51, 1.0),),
        ]),
      ),
    );
  }
}
