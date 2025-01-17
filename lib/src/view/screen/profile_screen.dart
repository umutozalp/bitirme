import 'package:bitirme/service/auth.dart';
import 'package:bitirme/src/view/screen/address_screen.dart';
import 'package:bitirme/src/view/screen/home_screen.dart';
import 'package:bitirme/src/view/screen/orders_screen.dart';
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
  static const primaryColor = Color.fromRGBO(10, 61, 51, 1.0);

  // Sayfa geçiş animasyonları için ortak metot.
  PageRouteBuilder _createPageRoute(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(
          opacity: animation,
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = Auth().currentUser;
    if (currentUser == null) {
      return const LoginRegisterPage();
    }

    // Kullanıcı bilgilerini doğrudan al
    final userName = currentUser.displayName ?? "Ad Bulunamadı";
    final userEmail = currentUser.email ?? "Email Bulunamadı";

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        backgroundColor: primaryColor,
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
                      backgroundColor: primaryColor,
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
                          userName,
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          userEmail,
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

            _buildProfileOption(
              icon: Icon(Icons.edit, color: primaryColor),
              context,
              title: "Kullanıcı Bilgilerim",
              onTap: () {
                Navigator.push(context, _createPageRoute(UserInfo()));
              },
            ),

            _buildProfileOption(
              icon: Icon(Icons.home, color: primaryColor),
              context,
              title: "Adreslerim",
              onTap: () {
                Navigator.push(context, _createPageRoute(AddressScreen()));
              },
            ),

            _buildProfileOption(
              icon: Icon(Icons.history, color: primaryColor),
              context,
              title: "Siparişlerim",
              onTap: () {
                Navigator.push(context, _createPageRoute(OrdersScreen()));
              },
            ),

            _buildProfileOption(
              icon: Icon(Icons.credit_card, color: primaryColor),
              context,
              title: "Ödeme Yöntemlerim",
              onTap: () {
                Navigator.push(context, _createPageRoute(PaymentScreen()));
              },
            ),
            _buildProfileOption(
                context,
                title: "Çıkış Yap",
                onTap: () async {
                  await Auth().signOut();
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                  );
                },
                icon: Icon(
                  Icons.logout,
                  color: primaryColor,
                ),
              )
          ],
        ),
      ),
    );
  }

  //
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
              offset: Offset(0, 3),),],),
        child: Row(
          children: [
            icon,
            SizedBox(width: 3),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),),),
            Icon(Icons.arrow_forward_ios, size: 18, color: primaryColor,),
          ],
        ),
      ),
    );
  }
}
