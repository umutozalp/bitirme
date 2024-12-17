import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Sekme sayısı: Kullanıcı Bilgileri, Ödeme Bilgileri, Adres Bilgileri
      child: Scaffold(
        appBar: AppBar(
            title: const Text('Profil', style: TextStyle(fontSize: 24)),
        centerTitle: true,
        backgroundColor: Colors.blueAccent,
        bottom: const TabBar(
          indicatorColor: Colors.white,
          tabs: [
            Tab(icon: Icon(Icons.person), text: "Bilgilerim"),
            Tab(icon: Icon(Icons.payment), text: "Ödemelerim"),
            Tab(icon: Icon(Icons.location_on), text: "Adreslerim"),
          ],
        ),
      ),
      body: const TabBarView(
        children: [
          UserInfoTab(),
          PaymentInfoTab(),
          AddressInfoTab(),
        ],
      ),
    ),
    );
  }
}

/// Kullanıcı Bilgileri Sekmesi
class UserInfoTab extends StatelessWidget {
  const UserInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          CircleAvatar(
            radius: 60,
            backgroundImage: AssetImage('assets/images/profile_pic.png'),
          ),
          SizedBox(height: 20),
          Text("Sina Yıldırım",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24)),
          SizedBox(height: 10),
          Text("sinayildirim@gmail.com",
              style: TextStyle(fontSize: 18, color: Colors.grey)),
          SizedBox(height: 10),
          Text("+90 555 123 45 67", style: TextStyle(fontSize: 18)),
        ],
      ),
    );
  }
}

/// Ödeme Bilgileri Sekmesi
class PaymentInfoTab extends StatelessWidget {
  const PaymentInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.credit_card, color: Colors.blueAccent),
            title: const Text("Kredi Kartı"),
            subtitle: const Text("**** **** **** 1234"),
            trailing: const Icon(Icons.edit),
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.account_balance, color: Colors.green),
            title: const Text("Banka Hesabı"),
            subtitle: const Text("TR12 1234 5678 9101 1121 00"),
            trailing: const Icon(Icons.edit),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

/// Adres Bilgileri Sekmesi
class AddressInfoTab extends StatelessWidget {
  const AddressInfoTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Card(
          child: ListTile(
            leading: const Icon(Icons.home, color: Colors.orange),
            title: const Text("Ev Adresi"),
            subtitle: const Text("Cumhuriyet Mah. No:12 Daire:34, İstanbul"),
            trailing: const Icon(Icons.edit),
            onTap: () {},
          ),
        ),
        Card(
          child: ListTile(
            leading: const Icon(Icons.work, color: Colors.blueGrey),
            title: const Text("İş Adresi"),
            subtitle: const Text("Sanayi Mah. No:45 Kat:3, Ankara"),
            trailing: const Icon(Icons.edit),
            onTap: () {},
          ),
        ),
      ],
    );
  }
}
